defmodule SkylineProposals.Jobs.UpdateHubspotWithSightenProposalInfo do
  use Oban.Worker, queue: :skyline_proposals

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    with {:ok,
          %SightenApi.ReceivedSightenWebhook{
            stage_name: sighten_stage_name
          } = received_webhook} <-
           SightenApi.ReceivedSightenWebhook.new(received_body_params) do
      case sighten_stage_name do
        "Trigger—Send Final Proposal to Hubspot and set Deal Stage to \"Design Complete - Pending Review\"" ->
          procedure(received_webhook)

        "Trigger—Send Newest Proposal to Hubspot and set Deal Stage to \"Design Complete - Pending Review\"" ->
          procedure(received_webhook)

        "Reset Trigger/No Trigger" ->
          {:ok, "Resetting Trigger"}

        nil ->
          msg = "No Sighten Stage Provided by Sighten"
          IO.puts(msg)
          {:ok, msg}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  defp procedure(%SightenApi.ReceivedSightenWebhook{
         site_id: site_id
       }) do
    IO.puts("INCOMING SIGHTEN SITE #{site_id}")
    IO.puts("Sending #{site_id}'s proposal to Hubspot")

    with {:ok,
          %{
            body: %{
              "contacts" => [
                %{
                  "first_name" => site_contact_first_name,
                  "last_name" => site_contact_last_name
                }
                | _tail
              ]
            }
          }} <- SightenApi.fetch_site_by_id(site_id) do
      with {:ok,
            %HubspotApi.DealList{results: [%HubspotApi.Deal{hubspot_deal_id: deal_id} | _tail]}} <-
             SkylineProposals.search_deals_for_site_id(site_id),
           {:ok, %{body: %{"results" => proposals}}} <-
             SightenApi.get_proposals_for_site_id(site_id),
           {:ok, proposal} <- find_hubspot_proposal(proposals),
           {:ok, proposal_id} <- fetch_proposal_id(proposal),
           {:ok, proposal_quote} <- fetch_proposal_quote(proposal),
           {:ok, install_cost} <- fetch_install_cost(proposal_quote),
           {:ok, system_size} <- fetch_system_capacity_kw(proposal_id),
           {:ok, usage_offset} <- fetch_site_usage_offset(proposal_id),
           {:ok, proposal_date_created} <- fetch_proposal_date_created(proposal_id),
           {:ok, system_production_in_first_year} <-
             fetch_system_production_in_first_year(proposal_id),
           {:ok, estimated_usage_in_first_year} <-
             fetch_site_estimated_usage_in_first_year(proposal_id),
           {:ok, module_model_count} <-
             fetch_array_module_count(proposal_id),
           {:ok, system_monthly_production_average} <-
             fetch_system_production_monthly_avg(proposal_id),
           {:ok, average_roof_pitch} <- fetch_array_tilt_average(proposal_id),
           {:ok, proposal_array_count} <- fetch_array_count(proposal_id),
           {:ok, proposal_inverter_size} <- fetch_inverter_rating_nominal(proposal_id),
           {:ok, proposal_module_size} <- fetch_module_rating_nominal(proposal_id),
           {:ok, proposal_module_model} <- fetch_module_model(proposal_id),
           {:ok, proposal_inverter_model} <- fetch_inverter_model(proposal_id),
           {:ok, proposal_efficiency_equipment} <- fetch_efficiency_equipment_type(proposal_id),
           {:ok, proposal_battery_model} <- fetch_battery_model(proposal_id),
           {:ok, proposal_battery_count} <- fetch_battery_count(proposal_id),
           {:ok, array_type} <- fetch_array_type(proposal_id),
           {:ok, financing_fees} <- fetch_financing_fees(proposal_id) do
        IO.puts(
          "Sending sighten data to hubspot deal https://app.hubspot.com/contacts/org/deal/#{deal_id}"
        )

        update_data = %{
          "base_cost" => install_cost,
          "array_type" => array_type |> Enum.uniq() |> Enum.join(", "),
          "average_roof_pitch" => average_roof_pitch,
          "estimated_monthly_production_average" => system_monthly_production_average,
          "estimated_usage_in_first_year" => estimated_usage_in_first_year,
          "module_count" => module_model_count,
          "proposal_array_count" => proposal_array_count,
          "proposal_battery_count" =>
            unless(proposal_battery_count == [],
              do: proposal_battery_count |> Enum.sum(),
              else: 0
            ),
          "proposal_battery_model" => proposal_battery_model |> to_string,
          "proposal_created_date" =>
            proposal_date_created
            |> TimeApi.parse_to_datetime()
            |> Timex.beginning_of_day()
            |> TimeApi.to_unix(:millisecond),
          "proposal_efficiency_equipment" =>
            proposal_efficiency_equipment
            |> Enum.join(", "),
          "proposal_inverter_model" => proposal_inverter_model,
          "proposal_inverter_size" => proposal_inverter_size,
          "proposal_module_model" => proposal_module_model,
          "proposal_module_size" => proposal_module_size,
          "proposal_url" => "https://engine.sighten.io/proposal/#{proposal_id}",
          "solar_offset" => usage_offset,
          "system_production_in_first_year" => system_production_in_first_year,
          "system_size" => system_size,
          "finance_cost" => financing_fees
        }

        HubspotApi.update_deal(deal_id, update_data)

        :ok
      else
        {:error, msg} ->
          IO.puts(msg)

          send_slack_sighten_trigger_error_message(%{
            "message" => msg,
            "first_name" => site_contact_first_name,
            "last_name" => site_contact_last_name
          })

          {:error, msg}
      end
    else
      {:ok,
       %{
         body: %{
           "contacts" => []
         }
       }} ->
        msg = "Could not find contact for site"
        IO.puts(msg)
        {:error, msg}

      {:ok,
       %{
         status: 404
       }} ->
        msg = "Could not find sighten site"
        IO.puts(msg)
        {:ok, msg}
    end
  end

  defp send_slack_sighten_trigger_error_message(%{
         "message" => msg,
         "first_name" => site_contact_first_name,
         "last_name" => site_contact_last_name
       }) do
    GenServer.cast(
      SkylineSlack.GenServer,
      {:send_slack_sighten_trigger_error,
       %{
         "message" => msg,
         "first_name" => site_contact_first_name,
         "last_name" => site_contact_last_name
       }}
    )
  end

  def find_hubspot_proposal(proposals) do
    result = Enum.find(proposals, fn %{"name" => name} -> String.match?(name, ~r/hubspot/i) end)
    if(result, do: {:ok, result}, else: {:error, "Could not find hubspot proposal"})
  end

  defp fetch_proposal_id(nil) do
    {:error, "Cannot find proposal id"}
  end

  defp fetch_proposal_id(proposal) do
    {:ok, Map.get(proposal, "uuid")}
  end

  defp fetch_proposal_quote(nil) do
    {:error, "Could not find proposal quote"}
  end

  defp fetch_proposal_quote(proposal) do
    with [quote_id | _tail] <- Map.get(proposal, "quotes"),
         {:ok, %{body: body} = _resp} <- SightenApi.fetch_quote_by_id(quote_id) do
      {:ok, body}
    else
      _error -> nil
    end
  end

  defp fetch_install_cost(nil) do
    {:error, "Could not find install cost"}
  end

  defp fetch_install_cost(proposal_quote) do
    {:ok, proposal_quote |> Map.get("install_cost")}
  end

  # TODO: Stuff from data access layer is weird...
  # TODO: need way to get same as hubspot proposal?
  defp fetch_system_capacity_kw(proposal_id) do
    with {:ok, [%{"system_capacity_kw" => [system_size]}]} <-
           SightenApi.fetch_system_capacity_kw(:proposal, proposal_id) do
      {:ok, system_size * 1000}
    else
      {:ok, [%{"system_capacity_kw" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find system size"}
    end
  end

  defp fetch_site_usage_offset(proposal_id) do
    with {:ok, [%{"site_usage_offset" => [usage_offset]}]} <-
           SightenApi.fetch_site_usage_offset(:proposal, proposal_id) do
      {:ok, usage_offset}
    else
      {:ok, [%{"site_usage_offset" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find usage offset"}
    end
  end

  defp fetch_proposal_date_created(proposal_id) do
    with {:ok, [%{"proposal_date_created" => proposal_date_created}]} <-
           SightenApi.fetch_proposal_date_created(:proposal, proposal_id) do
      {:ok, proposal_date_created}
    else
      _error -> {:error, "Could not find proposal date created"}
    end
  end

  defp fetch_system_production_in_first_year(proposal_id) do
    with {:ok,
          [
            %{"system_production_in_first_year" => [system_production_in_first_year]}
          ]} <-
           SightenApi.fetch_system_production_in_first_year(:proposal, proposal_id) do
      {:ok, system_production_in_first_year}
    else
      {:ok,
       [
         %{"system_production_in_first_year" => []}
       ]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find system production in first year"}
    end
  end

  defp fetch_site_estimated_usage_in_first_year(proposal_id) do
    with {:ok,
          [
            %{"site_estimated_usage_in_first_year" => site_estimated_usage_in_first_year}
          ]} <-
           SightenApi.fetch_site_estimated_usage_in_first_year(:proposal, proposal_id) do
      {:ok, site_estimated_usage_in_first_year}
    else
      _error -> {:error, "Could not find estimated usage in first year"}
    end
  end

  defp fetch_array_tilt_average(proposal_id) do
    with {:ok,
          [
            %{"array_tilt" => list_of_tilts}
          ]} <-
           SightenApi.fetch_array_tilt(:proposal, proposal_id),
         sum <- Enum.sum(list_of_tilts),
         average <- sum / length(list_of_tilts) do
      {:ok, average}
    else
      _error -> {:error, "Could not find array tilts"}
    end
  end

  defp fetch_array_count(proposal_id) do
    with {:ok,
          [
            %{"array_count" => count_of_arrays}
          ]} <-
           SightenApi.fetch_array_count(:proposal, proposal_id) do
      {:ok, count_of_arrays}
    else
      _error -> {:error, "Could not find array count"}
    end
  end

  defp fetch_array_type(proposal_id) do
    with {:ok,
          [
            %{"array_type" => array_type}
          ]} <-
           SightenApi.fetch_array_type(:proposal, proposal_id) do
      {:ok, array_type}
    else
      _error -> {:error, "Could not find array_type"}
    end
  end

  defp fetch_inverter_rating_nominal(proposal_id) do
    with {:ok, [%{"inverter_rating_nominal" => [inverter_rating_nominal]}]} <-
           SightenApi.fetch_inverter_rating_nominal(:proposal, proposal_id) do
      {:ok, inverter_rating_nominal}
    else
      {:ok, [%{"inverter_rating_nominal" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find inverter_rating_nominal"}
    end
  end

  defp fetch_module_rating_nominal(proposal_id) do
    with {:ok, [%{"module_rating_nominal" => [module_rating_nominal]}]} <-
           SightenApi.fetch_module_rating_nominal(:proposal, proposal_id) do
      {:ok, module_rating_nominal}
    else
      {:ok, [%{"module_rating_nominal" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find module_rating_nominal"}
    end
  end

  defp fetch_module_model(proposal_id) do
    with {:ok, [%{"module_model" => [module_model]}]} <-
           SightenApi.fetch_module_model(:proposal, proposal_id) do
      {:ok, module_model}
    else
      {:ok, [%{"module_model" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find module_model"}
    end
  end

  defp fetch_inverter_model(proposal_id) do
    with {:ok, [%{"inverter_model" => [inverter_model]}]} <-
           SightenApi.fetch_inverter_model(:proposal, proposal_id) do
      {:ok, inverter_model}
    else
      {:ok, [%{"inverter_model" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find inverter_model"}
    end
  end

  defp fetch_efficiency_equipment_type(proposal_id) do
    with {:ok, [%{"efficiency_equipment_type" => efficiency_equipment_type}]} <-
           SightenApi.fetch_efficiency_equipment_type(:proposal, proposal_id) do
      {:ok, efficiency_equipment_type}
    else
      _error ->
        {:error, "Could not find efficiency_equipment_type"}
    end
  end

  defp fetch_battery_model(proposal_id) do
    with {:ok, [%{"battery_model" => [battery_model]}]} <-
           SightenApi.fetch_battery_model(:proposal, proposal_id) do
      {:ok, battery_model}
    else
      {:ok, [%{"battery_model" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find battery_model"}
    end
  end

  defp fetch_battery_count(proposal_id) do
    with {:ok, [%{"battery_count" => battery_count}]} <-
           SightenApi.fetch_battery_count(:proposal, proposal_id) do
      {:ok, battery_count}
    else
      _error ->
        {:error, "Could not find battery_count"}
    end
  end

  defp fetch_array_module_count(proposal_id) do
    with {:ok, [%{"array_module_count" => system_module_model_counts}]} <-
           SightenApi.fetch_array_module_count(:proposal, proposal_id),
         system_module_model_counts <- system_module_model_counts |> Enum.sum() do
      {:ok, system_module_model_counts}
    else
      {:ok, [%{"array_module_count" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find module counts"}
    end
  end

  defp fetch_system_production_monthly_avg(proposal_id) do
    with {:ok, [%{"system_production_monthly_avg" => [system_production_monthly_avg]}]} <-
           SightenApi.fetch_system_production_monthly_avg(:proposal, proposal_id) do
      {:ok, system_production_monthly_avg}
    else
      {:ok, [%{"system_production_monthly_avg" => []}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find system production monthly average"}
    end
  end

  defp fetch_financing_fees(proposal_id) do
    with {:ok, [%{"financing_fees" => financing_fees}]} <-
           SightenApi.fetch_financing_fees(:proposal, proposal_id) do
      {:ok, financing_fees}
    else
      {:ok, [%{"financing_fees" => nil}]} ->
        {:ok, nil}

      _error ->
        {:error, "Could not find financing fees"}
    end
  end
end
