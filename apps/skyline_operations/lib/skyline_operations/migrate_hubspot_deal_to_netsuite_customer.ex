defmodule SkylineOperations.MigrateHubspotDealToNetsuiteCustomer do
  @moduledoc """
  Contains a long function to migrate hubspot properties to a netsuite customer map

  THIS FUNCTION PROVIDES THE PROPERTIES
  SkylineOperations.get_hubspot_properties_for_netsuite()
  """

  @doc """
  Takes a map of hubspot properties and migrates it to a netsuite customer map

  Returns %{"netsuite_field" => "hubspot_value"}

  ## Error Notes
  If the Hubspot record does not have a state, the Utility Company will not set
  correctly in Netsuite. The Netsuite Utility Company field depends on the
  state. So beware of this if you see a Netsuite error about utility company,
  check the Hubspot state.
  """
  def exec(hubspot_properties) do
    %{
      "category" => "1",
      "entitystatus" => "13",
      "custentity_bb_started_from_proj_template" => "209",
      "altphone" => hubspot_properties["mobile_phone_number"],
      "custentity_bb_battery_quantity" =>
        hubspot_properties["proposal_battery_count"]
        |> (fn count ->
              unless is_nil(count) do
                {int, _} = Integer.parse(count)
                int
              else
                nil
              end
            end).(),
      "custentity_bb_fin_install_per_watt_amt" =>
        hubspot_properties["ppw"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {float, _} = Float.parse(string)

                float / 1000
            end).(),
      "custentity_bb_fin_prelim_purch_price_amt" =>
        hubspot_properties["total_amount"]
        |> (fn string ->
              unless is_nil(string) do
                {int, _} = Integer.parse(string)
                int
              else
                nil
              end
            end).(),
      "custentity_bb_financier_customer" =>
        hubspot_properties["finance_type"]
        |> (fn finance_type ->
              dictionary = SkylineOperations.Financier.dictionary()

              dictionary[finance_type]
            end).(),
      "custentity_bb_financier_payment_schedule" =>
        hubspot_properties["finance_type"]
        |> (fn finance_type ->
              dictionary = SkylineOperations.PaymentSchedule.dictionary()

              dictionary[finance_type]
            end).(),
      "custentity_bb_financing_type" =>
        hubspot_properties["finance_type"]
        |> (fn finance_type ->
              dictionary = SkylineOperations.FinancingType.dictionary()

              dictionary[finance_type]
            end).(),
      "custentity_bb_home_owner_phone" => hubspot_properties["phone_number"],
      "custentity_bb_home_owner_primary_email" => hubspot_properties["email"],
      "custentity_bb_install_address_1_text" => hubspot_properties["street_address"],
      "custentity_bb_install_city_text" => hubspot_properties["city"],
      "custentity_bb_install_state" =>
        hubspot_properties["state_region"]
        |> SkylineOperations.States.state_to_abbreviation()
        |> (fn state_abb ->
              %NetsuiteApi.State{netsuite_state_id: netsuite_state_id} =
                Repo.get_by!(NetsuiteApi.State, name: state_abb)

              netsuite_state_id
            end).(),
      "custentity_bb_install_zip_code_text" => hubspot_properties["zip"],
      "custentity_bb_inverter_quantity_num" =>
        hubspot_properties["inverter_count"]
        |> (fn string ->
              unless is_nil(string) do
                {int, _} = Integer.parse(string)
                int
              else
                nil
              end
            end).(),
      "custentity_bb_marketing_campaign" =>
        hubspot_properties["lead_source"]
        |> (fn
              nil ->
                nil

              lead_source ->
                %{netsuite_lead_source_id: id} =
                  Repo.get_by!(NetsuiteApi.LeadSource, name: lead_source)

                id
            end).(),
      "custentity_bb_module_quantity_num" =>
        hubspot_properties["module_count"]
        |> (fn string ->
              unless is_nil(string) do
                {int, _} = Integer.parse(string)
                int
              else
                nil
              end
            end).(),
      "custentity_bb_roof_material_type" =>
        hubspot_properties["adders"]
        |> (fn
              nil -> nil
              string -> String.split(string, ";")
            end).()
        |> (fn
              nil ->
                [false]

              adders_list ->
                dictionary = SkylineOperations.RoofMaterials.dictionary()

                Enum.map(adders_list, fn adder ->
                  case adder do
                    "Roof (Metal)" ->
                      dictionary["Aluminum"]

                    "Roof (Wood Shake)" ->
                      dictionary["Wood shake"]

                    "Roof (Flat - Membrane)" ->
                      dictionary["Foam"]

                    "Roof (Concrete/Tile)" ->
                      dictionary["Concrete"]

                    "Roof (Composite)" ->
                      dictionary["Composite"]

                    "Roof (Gravel)" ->
                      dictionary["Gravel"]

                    "Roof (Spanish Tile)" ->
                      dictionary["Spanish tile"]

                    "Roof (Clay Tile)" ->
                      dictionary["Clay tile"]

                    _ ->
                      false
                  end
                end)
                |> Enum.filter(fn term -> term != false end)
            end).()
        |> List.first(),
      "custentity_bb_system_size_decimal" =>
        hubspot_properties["system_size"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {float, _} = Float.parse(string)
                float
            end).(),
      "custentity_bb_tilt_degrees_num" =>
        hubspot_properties["panel_tilt"]
        |> (fn string ->
              unless is_nil(string) do
                {int, _} = Integer.parse(string)
                int
              else
                nil
              end
            end).(),
      "custentity_bb_utility_company" =>
        hubspot_properties["utility_company"]
        |> (fn utility_company ->
              %NetsuiteApi.UtilityCompany{
                netsuite_utility_company_id: netsuite_utility_company_id
              } = Repo.get_by!(NetsuiteApi.UtilityCompany, name: utility_company)

              netsuite_utility_company_id
            end).()
        |> (fn
              utility_company when is_nil(utility_company) ->
                SkylineSlack.send_skycrm_helpdesk_message("""
                *Known SkyCRM Error While Creating Netsuite Customer*
                https://app.hubspot.com/contacts/org/deal/#{hubspot_properties["hs_object_id"]}

                The Utility Company is not known in Netsuite's Utility Company list and needs to be added.

                Please set the utility company manually in Netsuite for this record's Netsuite Customer and Project.

                This message does not have a retry link with it.
                """)

                utility_company

              utility_company ->
                utility_company
            end).(),
      "custentity_bb_project_location" =>
        hubspot_properties["install_area"]
        |> (fn
              nil ->
                throw({:error, "No install area"})

              install_area ->
                %{netsuite_location_id: id} =
                  Repo.get_by(NetsuiteApi.Location, name: install_area)

                to_string(id)
            end).(),
      "custentity_bb_warehouse_location" =>
        hubspot_properties["install_area"]
        |> (fn install_area ->
              %{netsuite_location_id: id} = Repo.get_by(NetsuiteApi.Location, name: install_area)
              to_string(id)
            end).(),
      "custentity_sk_battery_model" => hubspot_properties["proposal_battery_model"],
      "custentity_sk_cash_back" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Cashback/), do: true, else: false)
            end).(),
      "custentity_sk_closing_customer_notes" => hubspot_properties["closing_notes"],
      "custentity_sk_critter_guard" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Critter Guard/), do: true, else: false)
            end).(),
      "custentity_sk_ev_charger" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/EV Charger/), do: true, else: false)
            end).(),
      "custentity_sk_extended_invertery_warrant" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Extended Inverter Warranty/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_extended_product" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Extended Production Monitoring/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity2" => hubspot_properties["dealname"],
      "custentity_sk_inverter_model" => hubspot_properties["proposal_inverter_model"],
      "custentity_sk_led" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/LED/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_main_panel_upgrade" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Main Panel Upgrade/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_module_model" => hubspot_properties["proposal_module_model"],
      "custentity_sk_module_size" => hubspot_properties["proposal_module_size"],
      "custentity_sk_number_of_arrays" => hubspot_properties["proposal_array_count"],
      "custentity_sk_panel_skirts" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Panel Skirts/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_roof_pitch" => hubspot_properties["average_roof_pitch"],
      "custentity_sk_roof_repairs" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/New Roof/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_roof_reinforcement" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/New Roof/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_site_survey_date" => hubspot_properties["site_survey_completed"],
      "custentity_sk_smart_thermostat" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Smart Therm/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_tree_trimming" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Tree Trimming/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_trenching_ground_type" =>
        hubspot_properties["adders"]
        |> (fn
              nil -> [nil]
              string -> String.split(string, ";")
            end).()
        |> (fn adders_list ->
              dictionary = SkylineOperations.GroundMountTypes.dictionary()

              Enum.map(adders_list, fn adder ->
                case adder do
                  "Trenching (Dirt)" ->
                    dictionary["Dirt"]

                  "Trenching (Other)" ->
                    dictionary["Other"]

                  "Trenching (Concrete)" ->
                    dictionary["Concrete"]

                  _ ->
                    false
                end
              end)
              |> Enum.filter(fn term -> term != false end)
            end).()
        |> List.first(),
      "custentity_sk_trenching_length" =>
        hubspot_properties["trenching_distance"] |> parse_float(),
      "custentity_sk_upsized_inverter" =>
        hubspot_properties["adders"]
        |> (fn
              nil ->
                false

              string ->
                if(String.match?(string, ~r/Upsized Inverter/),
                  do: true,
                  else: false
                )
            end).(),
      "custentity_sk_utility_account_name" => hubspot_properties["utility_account_name"],
      "custentity_sk_utility_account_number" => hubspot_properties["utility_account_number"],
      "custentity_sk_xcel_premise_number" => hubspot_properties["premise_number"],
      "custentity_skl_hs_dealid" =>
        hubspot_properties["hs_object_id"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {int, _} = Integer.parse(string)
                int
            end).(),
      "custentity_skl_hubspot_id" =>
        HubspotApi.get_a_deals_associated_contact(hubspot_properties["hs_object_id"])
        |> (fn {:ok, contact} -> contact.hubspot_contact_id end).()
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {int, _} = Integer.parse(string)
                int
            end).(),
      "custentity_sk_proposal_link" => hubspot_properties["proposal_url"],
      "email" => hubspot_properties["email"],
      "firstname" => hubspot_properties["first_name"],
      "lastname" => hubspot_properties["last_name"],
      "custentity_sk_interest_rate" => hubspot_properties["sighten_contract_interest_rate"],
      "custentity_sk_finance_term_length" => hubspot_properties["sighten_contract_term_length"],
      "custentity_sk_array_type" => hubspot_properties["array_type"],
      "custentity_sk_sales_close_date" => hubspot_properties["closedate"],
      "custentity_skl_hs_hoa_note" => hubspot_properties["hoa___name___contact"],
      "custentity_bb_fin_total_fees_amount" => hubspot_properties["finance_cost"],
      "custentity_skl_hs_net_revenue" =>
        hubspot_properties["base_cost"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {float, _} = Float.parse(string)
                float
            end).(),
      "custentity_skl_hs_dealer_fee" =>
        hubspot_properties["finance_cost"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {float, _} = Float.parse(string)
                float
            end).(),
      "custentity_sk_sighten_site_id" => hubspot_properties["sighten_site_id"],
      "custentity_sk_sighten_quote_id" => hubspot_properties["sighten_quote_id"],
      "custentity_sk_sales_rep" =>
        hubspot_properties["hubspot_owner_id"] |> get_netsuite_employee_from_hubspot(),
      "custentity_skl_cashback_amount" =>
        hubspot_properties["cashback_amount"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {float, _} = Float.parse(string)
                float
            end).(),
      "custentity_skl_eagleview" =>
        hubspot_properties["eagleview"]
        |> (fn
              "true" -> true
              "false" -> false
              _ -> false
            end).(),
      "custentity_skl_household_size" =>
        hubspot_properties["household_size"]
        |> (fn
              string when is_nil(string) ->
                string

              string ->
                {int, _} = Integer.parse(string)
                int
            end).(),
      "custentity_skl_sales_adders" =>
        hubspot_properties["adders_goeverbright"]
        |> (fn
              "" ->
                nil

              nil ->
                nil

              adders ->
                items =
                  String.split(adders, ";")
                  |> Enum.map(fn
                    adder -> Repo.get_by(NetsuiteApi.SalesAdder, name: adder)
                  end)
                  |> Enum.map(fn
                    %{netsuite_sales_adder_id: id} -> %{"id" => id}
                  end)
                  |> Enum.filter(fn
                    nil -> false
                    _ -> true
                  end)

                %{"items" => items}
            end).(),
      "custentity_skl_sales_promises" =>
        hubspot_properties["promises"]
        |> (fn
              "" ->
                nil

              nil ->
                nil

              promises ->
                items =
                  String.split(promises, ";")
                  |> Enum.map(fn
                    promise -> Repo.get_by(NetsuiteApi.SalesPromise, name: promise)
                  end)
                  |> Enum.map(fn
                    %{netsuite_sales_promise_id: id} -> %{"id" => id}
                  end)
                  |> Enum.filter(fn
                    nil -> false
                    _ -> true
                  end)

                %{"items" => items}
            end).(),
      "custentity_skl_sales_setter" =>
        hubspot_properties["contact_owner"] |> get_netsuite_employee_from_hubspot(),
      "custentity_sk_referred_by" => hubspot_properties["referred_by"]

      # Uncomment custentitysk_firstprojectcreated to debug without making a project
      # "custentitysk_firstprojectcreated" => true
    }
    |> IO.inspect(limit: :infinity)
  end

  def get_netsuite_employee_from_hubspot(hubspot_owner_id) do
    %{email: email} = Repo.get_by!(HubspotApi.Owner, hubspot_owner_id: hubspot_owner_id)

    %{netsuite_employee_id: netsuite_employee_id} =
      Repo.get_by!(NetsuiteApi.Employee, email: email)

    netsuite_employee_id
  end

  defp parse_float(nil), do: nil
  defp parse_float(""), do: nil

  defp parse_float(string) do
    {float, _} = Float.parse(string)
    float
  end
end
