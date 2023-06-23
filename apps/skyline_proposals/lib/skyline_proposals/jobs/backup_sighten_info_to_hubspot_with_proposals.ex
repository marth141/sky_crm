defmodule SkylineProposals.Jobs.BackupSightenInfoToHubspotWithProposals do
  use Oban.Worker, queue: :skyline_proposals

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    with {:ok, update_data} <- get_data_for_update(received_body_params) do
      received_body_params["objectId"]
      |> HubspotApi.update_deal(update_data)
    end
  end

  def get_data_for_update(received_body_params) do
    with {:ok, deal_sighten_info} <-
           SkylineProposals.get_a_deals_sighten_info(received_body_params["objectId"]),
         {:ok, most_recent_proposal} <-
           SightenApi.fetch_proposals(deal_sighten_info.properties["sighten_site_id"])
           |> maybe_get_most_recent_proposal(),
         {:ok, [%{"system_capacity_kw" => [system_size]}]} <-
           SightenApi.fetch_system_capacity_kw(:proposal, most_recent_proposal["uuid"]),
         {:ok, proposal_quote_id} <- fetch_last_quote_from_proposal(most_recent_proposal),
         {:ok, amount} <-
           SightenApi.fetch_quote_install_cost(proposal_quote_id),
         {:ok, [%{"site_usage_offset" => [site_usage_offset]}]} <-
           SightenApi.fetch_site_usage_offset(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"proposal_date_created" => proposal_date_created}]} <-
           SightenApi.fetch_proposal_date_created(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"system_production_in_first_year" => [system_production_in_first_year]}]} <-
           SightenApi.fetch_system_production_in_first_year(
             :proposal,
             most_recent_proposal["uuid"]
           ),
         {:ok, [%{"site_estimated_usage_in_first_year" => site_estimated_usage_in_first_year}]} <-
           SightenApi.fetch_site_estimated_usage_in_first_year(
             :proposal,
             most_recent_proposal["uuid"]
           ),
         {:ok, [%{"array_module_count" => module_count}]} <-
           SightenApi.fetch_array_module_count(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"system_production_monthly_avg" => [system_production_monthly_avg]}]} <-
           SightenApi.fetch_system_production_monthly_avg(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"array_tilt" => list_of_array_tilt}]} <-
           SightenApi.fetch_array_tilt(:proposal, most_recent_proposal["uuid"]),
         average_array_tilts <-
           list_of_array_tilt |> Enum.sum() |> (fn sum -> sum / length(list_of_array_tilt) end).(),
         {:ok, [%{"array_count" => array_count}]} <-
           SightenApi.fetch_array_count(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"inverter_rating_nominal" => [inverter_rating_nominal]}]} <-
           SightenApi.fetch_inverter_rating_nominal(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"module_rating_nominal" => [module_rating_nominal]}]} <-
           SightenApi.fetch_module_rating_nominal(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"module_model" => [module_model]}]} <-
           SightenApi.fetch_module_model(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"inverter_model" => [inverter_model]}]} <-
           SightenApi.fetch_inverter_model(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"efficiency_equipment_type" => efficiency_equipment_type}]} <-
           SightenApi.fetch_efficiency_equipment_type(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"battery_model" => battery_model}]} <-
           SightenApi.fetch_battery_model(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"battery_count" => battery_count}]} <-
           SightenApi.fetch_battery_count(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"array_type" => array_type}]} <-
           SightenApi.fetch_array_type(:proposal, most_recent_proposal["uuid"]),
         {:ok, [%{"financing_fees" => financing_fees}]} <-
           SightenApi.fetch_financing_fees(:proposal, most_recent_proposal["uuid"]) do
      {:ok,
       %{
         "base_cost" => amount,
         "array_type" => array_type |> Enum.uniq() |> Enum.join(", "),
         "average_roof_pitch" => average_array_tilts,
         "estimated_monthly_production_average" => system_production_monthly_avg,
         "estimated_usage_in_first_year" => site_estimated_usage_in_first_year,
         "module_count" => module_count |> Enum.sum(),
         "proposal_array_count" => array_count,
         "proposal_battery_count" =>
           unless(battery_count == [], do: battery_count |> List.first(), else: 0),
         "proposal_battery_model" => battery_model |> to_string,
         "proposal_created_date" =>
           proposal_date_created
           |> TimeApi.parse_to_datetime()
           |> Timex.beginning_of_day()
           |> TimeApi.to_unix(:millisecond),
         "proposal_efficiency_equipment" =>
           efficiency_equipment_type
           |> Enum.join(", "),
         "proposal_inverter_model" => inverter_model,
         "proposal_inverter_size" => inverter_rating_nominal,
         "proposal_module_model" => module_model,
         "proposal_module_size" => module_rating_nominal,
         "proposal_url" => "https://engine.sighten.io/proposal/#{most_recent_proposal["uuid"]}",
         "solar_offset" => site_usage_offset,
         "system_production_in_first_year" => system_production_in_first_year,
         "system_size" => system_size,
         "finance_cost" => financing_fees
       }}
    else
      error ->
        error
    end
  end

  defp fetch_last_quote_from_proposal(proposal) do
    {:ok,
     proposal["quotes"]
     |> List.last()}
  end

  defp maybe_get_most_recent_proposal({:ok, list}) when is_list(list) do
    get_most_recent_proposal({:ok, list})
  end

  defp maybe_get_most_recent_proposal({:error, _} = error) do
    error
  end

  defp get_most_recent_proposal({:ok, list_of_proposals}) do
    {:ok,
     list_of_proposals
     |> Enum.map(fn proposal ->
       proposal
       |> Map.update!("date_updated", fn date -> TimeApi.parse_to_datetime(date) end)
       |> Map.update!("date_created", fn date -> TimeApi.parse_to_datetime(date) end)
     end)
     |> Enum.sort_by(fn proposal -> proposal["date_updated"] end, {:desc, DateTime})
     |> List.first()}
  end
end
