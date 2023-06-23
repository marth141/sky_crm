defmodule SkylineProposals.Jobs.BackupSightenInfoToHubspotWithCompletedContract do
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
         {:ok, completed_contract} <-
           SightenApi.fetch_completed_contract(deal_sighten_info.properties["sighten_site_id"])
           |> maybe_get_most_recent_contract(),
         {:ok, contract_signers_date_signed} <- get_most_recent_signed_date(completed_contract),
         {:ok, [%{"proposal_id" => list_of_proposals}]} <-
           SightenApi.fetch_quote_proposals(completed_contract["quote"]),
         proposal_id <- list_of_proposals |> List.last(),
         {:ok, [%{"system_capacity_kw" => system_size}]} <-
           SightenApi.fetch_system_capacity_kw(:quote, completed_contract["quote"]),
         {:ok, amount} <-
           SightenApi.fetch_quote_install_cost(completed_contract["quote"]),
         {:ok, [%{"site_usage_offset" => site_usage_offset}]} <-
           SightenApi.fetch_site_usage_offset(:quote, completed_contract["quote"]),
         {:ok, [%{"proposal_date_created" => proposal_date_created}]} <-
           SightenApi.fetch_proposal_date_created(:proposal, proposal_id),
         {:ok, [%{"system_production_in_first_year" => system_production_in_first_year}]} <-
           SightenApi.fetch_system_production_in_first_year(:quote, completed_contract["quote"]),
         {:ok, [%{"site_estimated_usage_in_first_year" => site_estimated_usage_in_first_year}]} <-
           SightenApi.fetch_site_estimated_usage_in_first_year(
             :quote,
             completed_contract["quote"]
           ),
         {:ok, [%{"array_module_count" => module_count}]} <-
           SightenApi.fetch_array_module_count(:quote, completed_contract["quote"]),
         {:ok, [%{"system_production_monthly_avg" => system_production_monthly_avg}]} <-
           SightenApi.fetch_system_production_monthly_avg(:quote, completed_contract["quote"]),
         {:ok, [%{"array_tilt" => list_of_array_tilt}]} <-
           SightenApi.fetch_array_tilt(:quote, completed_contract["quote"]),
         average_array_tilts <-
           list_of_array_tilt |> Enum.sum() |> (fn sum -> sum / length(list_of_array_tilt) end).(),
         {:ok, [%{"array_count" => array_count}]} <-
           SightenApi.fetch_array_count(:quote, completed_contract["quote"]),
         {:ok, [%{"inverter_rating_nominal" => [inverter_rating_nominal]}]} <-
           SightenApi.fetch_inverter_rating_nominal(:quote, completed_contract["quote"]),
         {:ok, [%{"module_rating_nominal" => [module_rating_nominal]}]} <-
           SightenApi.fetch_module_rating_nominal(:quote, completed_contract["quote"]),
         {:ok, [%{"module_model" => [module_model]}]} <-
           SightenApi.fetch_module_model(:quote, completed_contract["quote"]),
         {:ok, [%{"inverter_model" => [inverter_model]}]} <-
           SightenApi.fetch_inverter_model(:quote, completed_contract["quote"]),
         {:ok, [%{"efficiency_equipment_type" => efficiency_equipment_type}]} <-
           SightenApi.fetch_efficiency_equipment_type(:quote, completed_contract["quote"]),
         {:ok, [%{"battery_model" => battery_model}]} <-
           SightenApi.fetch_battery_model(:quote, completed_contract["quote"]),
         {:ok, [%{"battery_count" => battery_count}]} <-
           SightenApi.fetch_battery_count(:quote, completed_contract["quote"]),
         {:ok, [%{"array_type" => array_type}]} <-
           SightenApi.fetch_array_type(:quote, completed_contract["quote"]),
         {:ok, [%{"financing_fees" => financing_fees}]} <-
           SightenApi.fetch_financing_fees(:quote, completed_contract["quote"]) do
      {:ok,
       %{
         "base_cost" => amount,
         "array_type" => array_type |> Enum.uniq() |> Enum.join(", "),
         "average_roof_pitch" => average_array_tilts,
         "date_sighten_contract_signed" =>
           contract_signers_date_signed
           |> Timex.beginning_of_day()
           |> TimeApi.to_unix(:millisecond),
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
         "proposal_url" => "https://engine.sighten.io/proposal/#{proposal_id}",
         "solar_offset" => site_usage_offset,
         "system_production_in_first_year" => system_production_in_first_year,
         "system_size" => system_size,
         "finance_cost" => financing_fees
       }}
    else
      {:error, "No Completed Contracts"} ->
        SkylineProposals.backup_sighten_info_to_hubspot_with_proposals(received_body_params)
        IO.puts("Created Oban Job BackupSightenInfoToHubspotWithProposals")

      error ->
        error
    end
  end

  defp maybe_get_most_recent_contract({:ok, list}) when is_list(list) do
    get_most_recent_contract({:ok, list})
  end

  defp maybe_get_most_recent_contract({:error, _} = error) do
    error
  end

  defp get_most_recent_signed_date(contract) do
    {:ok,
     contract["signers"]
     |> List.first()
     |> (fn contract -> contract["date_signed"] end).()}
  end

  defp get_most_recent_contract({:ok, list_of_contracts}) do
    {:ok,
     list_of_contracts
     |> Enum.map(fn contract ->
       signers = contract["signers"]

       contract
       |> Map.update("signers", signers, fn list_of_signers ->
         list_of_signers
         |> Enum.map(fn signer ->
           date_signed = signer["date_signed"]

           signer
           |> Map.update("date_signed", date_signed, fn date_signed ->
             date_signed |> TimeApi.parse_to_datetime()
           end)
         end)
         |> Enum.sort_by(fn signer -> signer["date_signed"] end, {:desc, DateTime})
       end)
     end)
     |> Enum.sort_by(
       fn contract ->
         signer = contract["signers"] |> List.first()
         signer["date_signed"]
       end,
       {:desc, DateTime}
     )
     |> List.first()}
  end
end
