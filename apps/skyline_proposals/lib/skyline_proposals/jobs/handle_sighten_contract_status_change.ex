defmodule SkylineProposals.Jobs.HandleSightenContractStatusChange do
  use Oban.Worker, queue: :skyline_sales

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params, id: oban_job_id, attempt: attempt}) do
    with quote_id <- received_body_params["quote"],
         {:ok, the_quote} <- SightenApi.fetch_quote_by_id(quote_id),
         contract_term <- the_quote.body["submission"]["contract_term"],
         interest_rate <- the_quote.body["submission"]["interest_rate"],
         site_id <- received_body_params["site"],
         {:ok, contracts} <- SightenApi.fetch_completed_contract(site_id),
         contract <-
           Enum.sort_by(
             contracts,
             fn contract -> (contract["signers"] |> List.first())["date_signed"] end,
             :desc
           )
           |> List.first(),
         first_signer <- contract["signers"] |> List.first(),
         contract_date_signed <- first_signer["date_signed"],
         {:ok, [%{"proposal_id" => proposal_ids}]} <- SightenApi.fetch_quote_proposals(quote_id),
         proposal_id <- proposal_ids |> List.last(),
         {:ok, [%{"system_capacity_kw" => system_size}]} <-
           SightenApi.fetch_system_capacity_kw(:quote, quote_id),
         {:ok, amount} <-
           SightenApi.fetch_quote_install_cost(quote_id),
         {:ok, [%{"site_usage_offset" => site_usage_offset}]} <-
           SightenApi.fetch_site_usage_offset(:quote, quote_id),
         {:ok, [%{"proposal_date_created" => proposal_date_created}]} <-
           SightenApi.fetch_proposal_date_created(:proposal, proposal_id),
         {:ok, [%{"system_production_in_first_year" => system_production_in_first_year}]} <-
           SightenApi.fetch_system_production_in_first_year(:quote, quote_id),
         {:ok, [%{"site_estimated_usage_in_first_year" => site_estimated_usage_in_first_year}]} <-
           SightenApi.fetch_site_estimated_usage_in_first_year(
             :quote,
             quote_id
           ),
         {:ok, [%{"array_module_count" => module_count}]} <-
           SightenApi.fetch_array_module_count(:quote, quote_id),
         {:ok, [%{"system_production_monthly_avg" => system_production_monthly_avg}]} <-
           SightenApi.fetch_system_production_monthly_avg(:quote, quote_id),
         {:ok, [%{"array_tilt" => list_of_array_tilt}]} <-
           SightenApi.fetch_array_tilt(:quote, quote_id),
         average_array_tilts <-
           list_of_array_tilt |> Enum.sum() |> (fn sum -> sum / length(list_of_array_tilt) end).(),
         {:ok, [%{"array_count" => array_count}]} <-
           SightenApi.fetch_array_count(:quote, quote_id),
         {:ok, [%{"inverter_rating_nominal" => [inverter_rating_nominal]}]} <-
           SightenApi.fetch_inverter_rating_nominal(:quote, quote_id),
         {:ok, [%{"module_rating_nominal" => [module_rating_nominal]}]} <-
           SightenApi.fetch_module_rating_nominal(:quote, quote_id),
         {:ok, [%{"module_model" => [module_model]}]} <-
           SightenApi.fetch_module_model(:quote, quote_id),
         {:ok, [%{"inverter_model" => [inverter_model]}]} <-
           SightenApi.fetch_inverter_model(:quote, quote_id),
         {:ok, [%{"efficiency_equipment_type" => efficiency_equipment_type}]} <-
           SightenApi.fetch_efficiency_equipment_type(:quote, quote_id),
         {:ok, [%{"battery_model" => battery_model}]} <-
           SightenApi.fetch_battery_model(:quote, quote_id),
         {:ok, [%{"battery_count" => battery_count}]} <-
           SightenApi.fetch_battery_count(:quote, quote_id),
         {:ok, [%{"array_type" => array_type}]} <-
           SightenApi.fetch_array_type(:quote, quote_id),
         {:ok, [%{"financing_fees" => financing_fees}]} <-
           SightenApi.fetch_financing_fees(:quote, quote_id),
         {:ok, [%{"array_inverter_count" => array_inverter_count}]} <-
           SightenApi.fetch_array_inverter_count(:quote, quote_id),
         # Pretty common that sighten contract failures are because the wrong
         # sighten site id is attached to the deal or not at all
         {:ok, %HubspotApi.DealList{results: results}} <-
           SkylineProposals.search_deals_for_site_id(site_id),
         %HubspotApi.Deal{} = first_hubspot_result <- results |> List.first(),
         hubspot_deal_id <- first_hubspot_result.hubspot_deal_id,
         properties <- %{
           "array_type" =>
             if(array_type == [],
               do: nil,
               else: array_type |> Enum.uniq() |> Enum.join(", ")
             ),
           "average_roof_pitch" => average_array_tilts,
           "base_cost" => amount |> to_decimal_string(),
           "date_sighten_contract_signed" =>
             contract_date_signed
             |> TimeApi.parse_to_datetime()
             |> Timex.beginning_of_day()
             |> TimeApi.to_unix(:millisecond),
           "estimated_monthly_production_average" => system_production_monthly_avg,
           "estimated_usage_in_first_year" =>
             site_estimated_usage_in_first_year |> to_decimal_string(),
           "finance_cost" =>
             if(is_nil(financing_fees),
               do: financing_fees |> nil_to_zero(),
               else: financing_fees |> to_decimal_string()
             ),
           "module_count" => module_count |> Enum.sum(),
           "proposal_array_count" => array_count,
           "proposal_battery_count" => battery_count |> Enum.sum(),
           "proposal_battery_model" =>
             if(battery_model == [],
               do: nil,
               else: battery_model |> Enum.uniq() |> Enum.join(", ")
             ),
           "proposal_created_date" =>
             if(is_nil(proposal_date_created),
               do: proposal_date_created,
               else:
                 proposal_date_created
                 |> TimeApi.parse_to_datetime()
                 |> Timex.beginning_of_day()
                 |> TimeApi.to_unix(:millisecond)
             ),
           "proposal_efficiency_equipment" =>
             if(efficiency_equipment_type == [],
               do: nil,
               else: efficiency_equipment_type |> Enum.uniq() |> Enum.join(", ")
             ),
           # Might chop
           "proposal_inverter_model" => inverter_model,
           # might chop
           "proposal_inverter_size" => inverter_rating_nominal,
           "proposal_module_model" => module_model,
           "proposal_module_size" => module_rating_nominal,
           "proposal_url" =>
             if(is_nil(proposal_id),
               do: proposal_id,
               else: "https://engine.sighten.io/proposal/#{proposal_id}"
             ),
           "solar_offset" => site_usage_offset,
           "system_production_in_first_year" =>
             system_production_in_first_year
             |> to_decimal_string(),
           "system_size" =>
             (system_size * 1000)
             |> to_decimal_string(),
           # Might chop
           "inverter_count" => array_inverter_count |> Enum.sum(),
           "panel_tilt" => average_array_tilts,
           "sighten_contract_interest_rate" => interest_rate,
           "sighten_contract_term_length" => contract_term,
           "amount" =>
             (amount +
                (financing_fees
                 |> (fn ff -> if(is_nil(ff), do: ff |> nil_to_zero(), else: ff) end).()))
             |> Float.round()
             |> to_decimal_string(),
           "sighten_quote_id" => quote_id
         },
         {:ok, %{status: 200}} <-
           HubspotApi.update_deal(hubspot_deal_id, properties) do
      {:ok, "Updated with contract info"}
      |> IO.inspect()
    else
      {:error, "Could not find deal with site id"} = error ->
        if attempt >= 10 do
          %SightenApi.Schemas.Site{contacts: contacts} =
            SightenApi.fetch_site_by_id(received_body_params["site"])

          %SightenApi.Schemas.Site.Contact{first_name: f_name, last_name: l_name} =
            List.first(contacts)

          SkylineSlack.send_skycrm_helpdesk_message("""
          *Known SkyCRM error occured while handling contract status change event*
          https://engine.goeverbright.com/address/#{received_body_params["site"]}

          To fix, please visit the goeverbirght link above and find #{f_name} #{l_name}.

          Then find the customer with that name in Hubspot and copy "#{received_body_params["site"]}" to the "sighten site id" field on the hubspot deal.

          retry job at
          https://skycrm.live/a/skyline_oban/live/#{oban_job_id}
          """)

          SkylineSlack.send_message_to_user_email("salessupport@org", """
          Hello there,

          It looks like #{f_name} #{l_name} has signed their contract and the EverBright was created manually and the EverBright ID was forgotten.

          This message was produced while trying to copy contract information to the customer's deal and was broken because of the manual creation and forgotten ID.

          Please copy "#{received_body_params["site"]}" onto #{f_name} #{l_name}'s Hubspot Deal under the "Sighten ID" property.

          This will prevent any further automation errors from happening for this record.

          When ready to retry, please ask Jason

          Thanks!
          """)

          SkylineSlack.send_message_to_user_email("jason@org", """
          Hello there,

          It looks like #{f_name} #{l_name} has signed their contract and the EverBright was created manually and the EverBright ID was forgotten.

          This message was produced while trying to copy contract information to the customer's deal and was broken because of the manual creation and forgotten ID.

          Please copy "#{received_body_params["site"]}" onto #{f_name} #{l_name}'s Hubspot Deal under the "Sighten ID" property.

          This will prevent any further automation errors from happening for this record.

          Retry at https://skycrm.live/a/skyline_oban/live/#{oban_job_id}

          Thanks!
          """)

          error
        else
          error
        end

      error ->
        {:error, error}
        |> IO.inspect()
    end
  end

  defp nil_to_zero(nil) do
    0
  end

  defp to_decimal_string(float) do
    float
    |> Float.to_string()
    |> Decimal.parse()
    |> (fn {decimal, _} -> decimal |> Decimal.to_string(:normal) end).()
  end
end
