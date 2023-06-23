defmodule InfoTech do
  @moduledoc """
  Documentation for `InfoTech`.
  """
  import Ecto.Query

  @doc """
  Hello world.

  ## Examples

      iex> InfoTech.hello()
      :world

  """
  def hello do
    :world
  end

  def get_custom_field_properties(custom_field_script_id) do
    IO.inspect(custom_field_script_id)

    with {:ok, %{body: body}} <-
           NetsuiteApi.suiteql(
             "select * from CustomField where scriptid = '#{String.upcase(custom_field_script_id)}'"
           ),
         %{"items" => [item | []]} <- Jason.decode!(body) do
      item
    else
      _ -> %{"name" => custom_field_script_id}
    end
  end

  def get_custom_field_name(custom_field_script_id) do
    get_custom_field_properties(custom_field_script_id)
    |> Map.get("name")
  end

  def get_hs_custom_field_properties(custom_field_id, object_type) do
    with {:ok, %{body: body}} <-
           HubspotApi.Client.get("/crm/v3/properties/#{object_type}/#{custom_field_id}") do
      body
    else
      _ -> nil
    end
  end

  def get_hs_custom_field_label(custom_field_id, object_type) do
    with valid <- get_hs_custom_field_properties(custom_field_id, object_type) do
      valid
      |> Map.get("label")
    else
      nil -> nil
    end
  end

  def create_netsuite_to_hubspot_map() do
    netsuite_to_hubspot_mapping = %{
      # "category" => "4",
      # "entitystatus" => "13",
      # "custentity_bb_started_from_proj_template" => "209",
      "altphone" => "mobile_phone_number",
      "custentity_bb_battery_quantity" => "proposal_battery_count",
      "custentity_bb_fin_install_per_watt_amt" => "ppw",
      "custentity_bb_fin_prelim_purch_price_amt" => "total_amount",
      # from financier
      "custentity_bb_financier_customer" => "finance_type",
      # from financier
      "custentity_bb_financier_payment_schedule" => "finance_type",
      # from financier
      "custentity_bb_financing_type" => "finance_type",
      "custentity_bb_home_owner_phone" => "phone_number",
      "custentity_bb_home_owner_primary_email" => "email",
      "custentity_bb_install_address_1_text" => "street_address",
      "custentity_bb_install_city_text" => "city",
      "custentity_bb_install_state" => "state_region",
      "custentity_bb_install_zip_code_text" => "zip",
      "custentity_bb_inverter_quantity_num" => "inverter_count",
      "custentity_bb_marketing_campaign" => "lead_source",
      "custentity_bb_module_quantity_num" => "module_count",
      # where string contains aluminum, wood shake, foam, concrete, composite, gravel, spanish tile, or clay tile
      "custentity_bb_roof_material_type" => "adders",
      "custentity_bb_system_size_decimal" => "system_size",
      "custentity_bb_tilt_degrees_num" => "panel_tilt",
      # associated record in Netsuite
      "custentity_bb_utility_company" => "utility_company",
      "custentity_bb_project_location" => "install_area",
      "custentity_bb_warehouse_location" => "install_area",
      "custentity_sk_battery_model" => "proposal_battery_model",
      # where string contains cashback
      "custentity_sk_cash_back" => "adders",
      "custentity_sk_closing_customer_notes" => "closing_notes",
      # where string contains critter guard
      "custentity_sk_critter_guard" => "adders",
      # where string contains ev charger
      "custentity_sk_ev_charger" => "adders",
      # where string contains extended inverter warranty
      "custentity_sk_extended_invertery_warrant" => "adders",
      # where string contains extended production monitoring
      "custentity_sk_extended_product" => "adders",
      "custentity2" => "dealname",
      "custentity_sk_inverter_model" => "proposal_inverter_model",
      # where string contains LED
      "custentity_sk_led" => "adders",
      # where string contains main panel upgrade
      "custentity_sk_main_panel_upgrade" => "adders",
      "custentity_sk_module_model" => "proposal_module_model",
      "custentity_sk_module_size" => "proposal_module_size",
      "custentity_sk_number_of_arrays" => "proposal_array_count",
      # where string contains panel skirts
      "custentity_sk_panel_skirts" => "adders",
      "custentity_sk_roof_pitch" => "average_roof_pitch",
      # where string contains new roof
      "custentity_sk_roof_repairs" => "adders",
      # where string contains new roof
      "custentity_sk_roof_reinforcement" => "adders",
      "custentity_sk_site_survey_date" => "site_survey_completed",
      # where string contains smart therm
      "custentity_sk_smart_thermostat" => "adders",
      # where string contains tree trimming
      "custentity_sk_tree_trimming" => "adders",
      # where string contains dirt, other, or concrete
      "custentity_sk_trenching_ground_type" => "adders",
      "custentity_sk_trenching_length" => "trenching_distance",
      # where string contains upsized inverter
      "custentity_sk_upsized_inverter" => "adders",
      "custentity_sk_utility_account_name" => "utility_account_name",
      "custentity_sk_utility_account_number" => "utility_account_number",
      "custentity_sk_xcel_premise_number" => "premise_number",
      "custentity_skl_hs_dealid" => "hs_deal_id",
      "custentity_skl_hubspot_id" => "hs_contact_id",
      "custentity_sk_proposal_link" => "proposal_url",
      "email" => "email",
      "firstname" => "first_name",
      "lastname" => "last_name",
      "custentity_sk_interest_rate" => "sighten_contract_interest_rate",
      "custentity_sk_finance_term_length" => "sighten_contract_term_length",
      "custentity_sk_array_type" => "array_type",
      "custentity_sk_sales_close_date" => "closedate",
      "custentity_skl_hs_hoa_note" => "hoa___name___contact",
      "custentity_bb_fin_total_fees_amount" => "finance_cost",
      "custentity_skl_hs_net_revenue" => "base_cost",
      "custentity_skl_hs_dealer_fee" => "finance_cost",
      "custentity_sk_sighten_site_id" => "sighten_site_id",
      "custentity_sk_sighten_quote_id" => "sighten_quote_id",
      "custentity_sk_sales_rep" => "hubspot_owner_id",
      "custentity_skl_cashback_amount" => "cashback_amount",
      "custentity_skl_eagleview" => "eagleview",
      "custentity_skl_household_size" => "household_size",
      # multi-select
      "custentity_skl_sales_adders" => "adders_goeverbright",
      # multi-select
      "custentity_skl_sales_promises" => "promises",
      "custentity_skl_sales_setter" => "contact_owner",
      "custentity_sk_referred_by" => "referred_by"
    }

    Enum.map(netsuite_to_hubspot_mapping, fn {k, v} ->
      [k |> get_custom_field_name(), v |> get_hs_custom_field_label("deal")]
    end)
    |> List.insert_at(0, ["Netsuite Field Internal Id", "Hubspot Field Internal Id"])
    |> write_to_csv("Hubspot Deal to Netsuite Customer and Project")
  end

  def backfill_hoa_note_from_ns_customer_to_ns_project() do
    get_netsuite_project_parent_child_relationships()
    # Get the project and it's related customer records
    |> Task.async_stream(fn %{
                              "netsuite_mid_customer_id" => ns_mid_customer_id,
                              "netsuite_top_customer_id" => ns_top_customer_id,
                              "netsuite_project_id" => ns_project_id
                            } ->
      %{
        "netsuite_mid_customer" =>
          Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: ns_mid_customer_id),
        "netsuite_top_customer" =>
          Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: ns_top_customer_id),
        "netsuite_project" =>
          Repo.get_by!(NetsuiteApi.Project, netsuite_project_id: ns_project_id)
      }
    end)
    |> Enum.to_list()
    # Turn each into a {netsuite_project_id, api_arguments} tuples
    |> Task.async_stream(fn {:ok,
                             %{
                               "netsuite_mid_customer" =>
                                 %NetsuiteApi.Customer{} = _netsuite_mid_customer,
                               "netsuite_top_customer" =>
                                 %NetsuiteApi.Customer{} = netsuite_top_customer,
                               "netsuite_project" => %NetsuiteApi.Project{} = netsuite_project
                             }} ->
      {
        netsuite_project.netsuite_project_id,
        %{
          "custentity_skl_hs_hoa_note" => netsuite_top_customer.custentity_skl_hs_hoa_note
        }
      }
    end)
    # Filter out all of the blank adders and promises
    |> Stream.filter(fn {:ok,
                         {_ns_project_id,
                          %{
                            "custentity_skl_hs_hoa_note" => hoa_note
                          }}} ->
      hoa_note != nil
    end)
    |> Stream.map(fn {:ok, {netsuite_project_id, %{"custentity_skl_hs_hoa_note" => hoa_note}}} ->
      [netsuite_project_id, hoa_note]
    end)
    |> Enum.to_list()
    |> List.insert_at(0, ["Internal ID", "HOA Note"])
    |> write_to_csv("backfill_hoa_note")

    # Send Update to Netsuite
    # |> Task.async_stream(
    #   fn {:ok, {netsuite_project_id, argument}} ->
    #     IO.inspect(netsuite_project_id)
    #     NetsuiteApi.force_update_job(netsuite_project_id, argument)
    #   end,
    #   timeout: :infinity
    # )
    # |> Stream.run()
  end

  def backfill_adders_and_promises_from_ns_customer_to_ns_project() do
    get_netsuite_project_parent_child_relationships()
    # Get the project and it's related customer records
    |> Task.async_stream(fn %{
                              "netsuite_mid_customer_id" => ns_mid_customer_id,
                              "netsuite_top_customer_id" => ns_top_customer_id,
                              "netsuite_project_id" => ns_project_id
                            } ->
      %{
        "netsuite_mid_customer" =>
          Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: ns_mid_customer_id),
        "netsuite_top_customer" =>
          Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: ns_top_customer_id),
        "netsuite_project" =>
          Repo.get_by!(NetsuiteApi.Project, netsuite_project_id: ns_project_id)
      }
    end)
    |> Enum.to_list()
    # Turn each into a {netsuite_project_id, api_arguments} tuples
    |> Task.async_stream(fn {:ok,
                             %{
                               "netsuite_mid_customer" =>
                                 %NetsuiteApi.Customer{} = _netsuite_mid_customer,
                               "netsuite_top_customer" =>
                                 %NetsuiteApi.Customer{} = netsuite_top_customer,
                               "netsuite_project" => %NetsuiteApi.Project{} = netsuite_project
                             }} ->
      {
        netsuite_project.netsuite_project_id,
        %{
          "custentity_skl_sales_adders" => %{
            "items" =>
              netsuite_top_customer.custentity_skl_sales_adders
              |> (fn
                    nil -> ""
                    item -> item
                  end).()
              |> String.replace(" ", "")
              |> String.split(",")
              |> Enum.map(fn number -> %{"id" => number} end)
          },
          "custentity_skl_sales_promises" => %{
            "items" =>
              netsuite_top_customer.custentity_skl_sales_promises
              |> (fn
                    nil -> ""
                    item -> item
                  end).()
              |> String.replace(" ", "")
              |> String.split(",")
              |> Enum.map(fn number -> %{"id" => number} end)
          }
        }
      }
    end)
    # Filter out all of the blank adders and promises
    |> Stream.filter(fn {:ok,
                         {_ns_project_id,
                          %{
                            "custentity_skl_sales_adders" => %{"items" => adders},
                            "custentity_skl_sales_promises" => %{"items" => promises}
                          }}} ->
      adders != [%{"id" => ""}] and promises != [%{"id" => ""}]
    end)
    |> Enum.to_list()
    # Send Update to Netsuite
    |> Task.async_stream(
      fn {:ok, {netsuite_project_id, argument}} ->
        IO.inspect(netsuite_project_id)
        NetsuiteApi.force_update_job(netsuite_project_id, argument)
      end,
      timeout: :infinity
    )
    |> Enum.to_list()
  end

  def get_netsuite_project_parent_child_relationships() do
    projects_query =
      from(p in NetsuiteApi.Project,
        select: %{"ns_mid_customer" => p.parent, "ns_project_id" => p.netsuite_project_id}
      )

    mid_customers =
      Repo.all(projects_query)
      |> Task.async_stream(fn
        %{"ns_mid_customer" => nil} ->
          nil

        %{
          "ns_mid_customer" => ns_mid_customer,
          "ns_project_id" => netsuite_project_id
        } ->
          {Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: ns_mid_customer),
           netsuite_project_id}
      end)
      |> Enum.to_list()

    relationships =
      Enum.map(mid_customers, fn
        {:ok, nil} ->
          nil

        {:ok, {%NetsuiteApi.Customer{parent: mid_parent} = mid_customer, netsuite_project_id}}
        when not is_nil(mid_parent) ->
          %NetsuiteApi.Customer{} =
            top_customer = Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: mid_parent)

          %{
            "netsuite_top_customer_id" => top_customer.netsuite_customer_id,
            "netsuite_mid_customer_id" => mid_customer.netsuite_customer_id,
            "netsuite_project_id" => netsuite_project_id
          }

        {:ok, {%NetsuiteApi.Customer{parent: mid_parent} = _mid_customer, _netsuite_project_id}}
        when is_nil(mid_parent) ->
          nil
      end)
      |> Enum.filter(fn obj -> not is_nil(obj) end)
      |> Enum.map(fn
        %{
          "netsuite_top_customer_id" => top_customer_id,
          "netsuite_mid_customer_id" => mid_customer_id,
          "netsuite_project_id" => netsuite_project_id
        } ->
          [top_customer_id, mid_customer_id, netsuite_project_id]
      end)
      |> List.insert_at(0, ["Parent Customer Id", "Child Customer Id", "Project Id"])
      |> write_to_csv("netsuite_project_parent_child_relationships")

    relationships
  end

  def backfill_referred_by_from_hubspot_to_netsuite() do
    query =
      from(n in NetsuiteApi.Project,
        where: not is_nil(n.custentity_skl_hs_dealid),
        select: {n.netsuite_project_id, n.custentity_skl_hs_dealid},
        order_by: {:desc, n.netsuite_project_id}
      )

    Repo.all(query)
    |> Task.async_stream(
      fn {ns_project_id, hs_deal_id} ->
        %HubspotApi.Deal{properties: %{"referred_by" => referred_by}} =
          Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: hs_deal_id)

        {ns_project_id, referred_by}
      end,
      timeout: :infinity
    )
    |> Task.async_stream(fn
      {:ok, {ns_project_id, nil}} ->
        {ns_project_id, nil}

      {:ok, {ns_project_id, referred_by}} ->
        {ns_project_id, referred_by}
    end)
    |> Stream.filter(fn {:ok, {_ns_project_id, referred_by}} ->
      not is_nil(referred_by) and not (referred_by == "")
    end)
    |> Enum.to_list()
    |> Task.async_stream(
      fn {:ok, {ns_project_id, referred_by}} ->
        IO.inspect({ns_project_id, referred_by})

        # NetsuiteApi.force_update_job(ns_project_id, %{
        #   "custentity_sk_sales_close_date" => close_date
        # })
        [
          ns_project_id,
          referred_by
        ]
      end,
      timeout: :infinity
    )
    |> Stream.map(fn {:ok, thing} -> thing end)
    |> Enum.to_list()
    |> List.insert_at(0, ["Netsuite Project ID", "Referred By"])
    |> InfoTech.write_to_csv("project_referred_bys")
  end

  def backfill_closedate_from_hubspot_to_netsuite() do
    query =
      from(n in NetsuiteApi.Project,
        where: not is_nil(n.custentity_skl_hs_dealid),
        select: {n.netsuite_project_id, n.custentity_skl_hs_dealid},
        order_by: {:desc, n.netsuite_project_id}
      )

    Repo.all(query)
    |> Task.async_stream(
      fn {ns_project_id, hs_deal_id} ->
        %{properties: %{"closedate" => close_date}} =
          Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: hs_deal_id)

        {ns_project_id, close_date}
      end,
      timeout: :infinity
    )
    |> Task.async_stream(fn
      {:ok, {ns_project_id, nil}} ->
        {ns_project_id, nil}

      {:ok, {ns_project_id, close_date}} ->
        {ns_project_id, close_date}
    end)
    |> Stream.filter(fn {:ok, {_ns_project_id, close_date}} ->
      not is_nil(close_date) and not (close_date == "")
    end)
    |> Enum.to_list()
    |> Task.async_stream(
      fn {:ok, {ns_project_id, close_date}} ->
        IO.inspect({ns_project_id, close_date})

        # NetsuiteApi.force_update_job(ns_project_id, %{
        #   "custentity_sk_sales_close_date" => close_date
        # })
        [
          ns_project_id,
          close_date
          |> Timex.parse!("{ISO:Extended:Z}")
          |> Timex.to_date()
          |> (fn %Date{day: day, month: month, year: year} -> "#{month}/#{day}/#{year}" end).()
        ]
      end,
      timeout: :infinity
    )
    |> Stream.map(fn {:ok, thing} -> thing end)
    |> Enum.to_list()
    |> List.insert_at(0, ["Netsuite Project ID", "Close Date"])
    |> InfoTech.write_to_csv("project_close_dates")
  end

  def backfill_lead_source() do
    query =
      from(n in NetsuiteApi.Project,
        where: not is_nil(n.custentity_skl_hs_dealid),
        select: {n.netsuite_project_id, n.custentity_skl_hs_dealid},
        order_by: {:desc, n.netsuite_project_id}
      )

    Repo.all(query)
    |> Task.async_stream(
      fn {ns_project_id, hs_deal_id} ->
        %{properties: %{"lead_source" => lead_source}} =
          Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: hs_deal_id)

        {ns_project_id, lead_source}
      end,
      timeout: :infinity
    )
    |> Task.async_stream(fn
      {:ok, {ns_project_id, nil}} ->
        {ns_project_id, nil}

      {:ok, {ns_project_id, lead_source}} ->
        %{netsuite_lead_source_id: ns_lead_source_id} =
          Repo.get_by!(NetsuiteApi.LeadSource, name: lead_source)

        {ns_project_id, ns_lead_source_id}
    end)
    |> Stream.filter(fn {:ok, {_ns_project_id, ns_lead_source_id}} ->
      not is_nil(ns_lead_source_id)
    end)
    |> Enum.to_list()
    |> Task.async_stream(
      fn {:ok, {ns_project_id, ns_lead_source_id}} ->
        IO.inspect({ns_project_id, ns_lead_source_id})

        NetsuiteApi.force_update_job(ns_project_id, %{
          "custentity_bb_marketing_campaign" => ns_lead_source_id
        })
      end,
      timeout: :infinity
    )
    |> Enum.to_list()
  end

  def backfill_sales_setter() do
    query =
      from(n in NetsuiteApi.Project,
        where: not is_nil(n.custentity_skl_hs_dealid),
        select: {n.netsuite_project_id, n.custentity_skl_hs_dealid}
      )

    Repo.all(query)
    |> Task.async_stream(
      fn {ns_project_id, hs_deal_id} ->
        {ns_project_id, HubspotApi.get_a_deals_associated_contacts(hs_deal_id)}
      end,
      timeout: :infinity
    )
    |> Stream.map(fn {:ok, {ns_project_id, {:ok, hs_contact_id}}} ->
      {ns_project_id, hs_contact_id}
    end)
    |> Task.async_stream(
      fn {ns_project_id, hs_contact_id} ->
        {ns_project_id, HubspotApi.get_a_contacts_owner(hs_contact_id)}
      end,
      timeout: :infinity
    )
    |> Task.async_stream(fn
      {:ok, {ns_project_id, hs_contact}} ->
        {ns_project_id,
         hs_contact["properties"]["hubspot_owner_id"]
         |> (fn
               nil ->
                 nil

               "" ->
                 nil

               hs_contact_owner_id ->
                 query =
                   from(h in HubspotApi.Owner, where: h.hubspot_owner_id == ^hs_contact_owner_id)

                 Repo.all(query)
                 |> (fn
                       [] ->
                         nil

                       [%HubspotApi.Owner{} = hs_contact_owner] ->
                         query =
                           from(n in NetsuiteApi.Employee,
                             where: n.email == ^hs_contact_owner.email
                           )

                         Repo.all(query)
                         |> (fn
                               [] ->
                                 nil

                               [%NetsuiteApi.Employee{} = employee] ->
                                 employee.netsuite_employee_id
                             end).()
                     end).()
             end).()}
    end)
    |> Stream.filter(fn {:ok, {_ns_project_id, owner_id}} -> not is_nil(owner_id) end)
    |> Task.async_stream(
      fn {:ok, {ns_project_id, ns_setter_id}} ->
        IO.inspect(ns_project_id)

        NetsuiteApi.force_update_job(ns_project_id, %{
          "custentity_skl_sales_setter" => ns_setter_id
        })
      end,
      timeout: :infinity
    )
    |> Enum.to_list()
  end

  def get_netsuite_project_by_ahj() do
    waterloo = "46"

    Repo.all(
      from(j in NetsuiteApi.Project, where: j.custentity_bb_auth_having_jurisdiction == ^waterloo)
    )
  end

  @spec get_failed_jobs_report_for_oban_worker(binary, binary) :: :ok
  def get_failed_jobs_report_for_oban_worker(worker, title) do
    Repo.all(
      from(j in Oban.Job,
        where: j.worker == ^worker and j.attempt > 1
      )
    )
    |> Enum.map(fn %Oban.Job{} = j ->
      %HubspotApi.Deal{} =
        deal = Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: j.args["objectId"])

      [
        j.worker,
        "https://app.hubspot.com/contacts/org/deal/#{j.args["objectId"]}",
        deal.properties["first_name"],
        deal.properties["last_name"],
        j.inserted_at
      ]
    end)
    |> List.insert_at(0, [
      "Worker",
      "Hubspot Deal",
      "Customer Fist Name",
      "Customer Last Name",
      "Inserted At"
    ])
    |> InfoTech.write_to_csv(title)
  end

  def get_available_oban_jobs() do
    Repo.all(from(j in Oban.Job, where: j.state == "available", select: j.id))
  end

  def get_oban_jobs_by_hubspot_deal_id(hubspot_id) do
    query = from(j in Oban.Job, where: j.args["objectId"] == ^hubspot_id)

    Repo.all(query)
  end

  def update_phone_numbers() do
    to_change =
      Repo.all(
        from(c in HubspotApi.Contact,
          select: {c.hubspot_contact_id, c.properties["phone"]},
          order_by: [desc: c.hubspot_contact_id]
        )
      )
      |> Enum.map(fn
        {id, number} -> {id, ExPhoneNumber.parse(number, "US")}
      end)
      |> Enum.filter(fn
        {_id, {atom, _result}} -> atom == :ok
      end)
      |> Enum.map(fn
        {id, {:ok, phone_number}} ->
          {id, ExPhoneNumber.format(phone_number, :e164)}
      end)
      |> Task.async_stream(
        fn {id, phone_number} -> force_update_contact(id, %{"phone" => phone_number}) end,
        timeout: :infinity
      )
      |> Enum.to_list()

    to_change
  end

  def rollback_migration(version) do
    Ecto.Migrator.with_repo(Repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def refresh_all() do
    NetsuiteApi.AuthorityHandlingJurisdictionCollector.refresh_cache()
    NetsuiteApi.CaseCollector.refresh_cache()
    NetsuiteApi.CustomerCollector.refresh_cache()
    NetsuiteApi.EmployeeCollector.refresh_cache()
    NetsuiteApi.LocationsCollector.refresh_cache()
    NetsuiteApi.ProjectCollector.refresh_cache()
    NetsuiteApi.SalesAddersCollector.refresh_cache()
    NetsuiteApi.SalesPromisesCollector.refresh_cache()
    NetsuiteApi.StateCollector.refresh_cache()
    NetsuiteApi.UtilityCompanyCollector.refresh_cache()
    HubspotApi.DealCollector.refresh_cache()
    HubspotApi.ContactCollector.refresh_cache()
    HubspotApi.OwnerCollector.refresh_cache()
  end

  @doc """
  This updates Netsuite records missing "dealer_fees" with the matching Hubspot "finance_cost"
  """
  def fix_missing_netsuite_dealer_fees_with_hubspot_finance_cost() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          is_nil(np.custentity_skl_hs_dealer_fee) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  @doc """
  This updates Netsuite records missing "net_revenue" with the matching Hubspot "base_cost"
  """
  def fix_missing_netsuite_net_revenue_with_hubspot_base_cost() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          is_nil(np.custentity_skl_hs_net_revenue) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  @doc """
  This updates Netsuite records missing "financier total fees" with the matching Hubspot "finance_cost"
  """
  def fix_missing_netsuite_financier_fees_with_hubspot_finance_cost() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          is_nil(np.custentity_bb_fin_total_fees_amount) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  @doc """
  This updates netsuite records missing Netsuite "preliminary purchase price" with the matching Hubspot "total_amount"
  """
  def fix_missing_netsuite_preliminary_price_with_hubspot_total_amount() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          is_nil(np.custentity_bb_fin_prelim_purch_price_amt) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["total_amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["total_amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["total_amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  @doc """
  This updates netsuite records missing Netsuite "preliminary purchase price" with the matching Hubspot "total_amount"
  """
  def fix_missing_netsuite_preliminary_price_with_hubspot_amount() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          is_nil(np.custentity_bb_fin_prelim_purch_price_amt) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  @doc """
  This is suppose to fix missing money values in Netsuite Records
  """
  def fix_missing_money() do
    # Query the database for all of the Netsuite Projects where any money field is empty
    Repo.all(
      from(np in NetsuiteApi.Project,
        where:
          (is_nil(np.custentity_bb_fin_prelim_purch_price_amt) or
             is_nil(np.custentity_bb_fin_total_fees_amount) or
             is_nil(np.custentity_skl_hs_net_revenue) or
             is_nil(np.custentity_skl_hs_dealer_fee)) and
            not is_nil(np.custentity_skl_hs_dealid),
        select: %{
          "hubspot_deal_id" => np.custentity_skl_hs_dealid,
          "netsuite_project_id" => np.netsuite_project_id,
          "netsuite_child_customer_id" => np.parent,
          "netsuite_parent_customer_id" => "to fill in later",
          "custentity_bb_fin_prelim_purch_price_amt" =>
            np.custentity_bb_fin_prelim_purch_price_amt,
          "custentity_bb_fin_total_fees_amount" => np.custentity_bb_fin_total_fees_amount,
          "custentity_skl_hs_net_revenue" => np.custentity_skl_hs_net_revenue,
          "custentity_skl_hs_dealer_fee" => np.custentity_skl_hs_dealer_fee
        }
      )
    )
    # Get the netsuite project's parent customer ids
    |> Enum.map(fn netsuite_project ->
      Map.update!(netsuite_project, "netsuite_parent_customer_id", fn _ ->
        case netsuite_project["netsuite_child_customer_id"] do
          nil ->
            nil

          _ ->
            customer =
              Repo.get_by!(NetsuiteApi.Customer,
                netsuite_customer_id: netsuite_project["netsuite_child_customer_id"]
              )

            customer.parent
        end
      end)
    end)
    # For each record in the list of moneyless Netsuite Projects, find their hubspot record
    |> Enum.map(fn netsuite_project ->
      hubspot_deal =
        Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: netsuite_project["hubspot_deal_id"])

      {hubspot_deal, netsuite_project}
    end)
    # For each of the Netsuite-Hubspot pairs, update the Netsuite Project with the Hubspot money values
    |> Task.async_stream(
      fn {hubspot_deal, netsuite_project} ->
        with :ok <-
               force_update_customer(
                 netsuite_project["netsuite_parent_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float(),
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "parent Customer Update")
               ),
             :ok <-
               force_update_customer(
                 netsuite_project["netsuite_child_customer_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float(),
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "child Customer Update")
               ),
             :ok <-
               force_update_job(
                 netsuite_project["netsuite_project_id"],
                 %{
                   "custentity_bb_fin_prelim_purch_price_amt" =>
                     hubspot_deal.properties["amount"]
                     |> parse_to_float(),
                   "custentity_bb_fin_total_fees_amount" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_net_revenue" =>
                     hubspot_deal.properties["base_cost"]
                     |> parse_to_float(),
                   "custentity_skl_hs_dealer_fee" =>
                     hubspot_deal.properties["finance_cost"]
                     |> parse_to_float()
                 }
                 |> IO.inspect(label: "Project Update")
               ) do
          {:ok, "Updated everything with money"}
        else
          error -> {:error, error} |> IO.inspect()
        end
      end,
      timeout: :infinity
    )
  end

  defp parse_to_float(value) when is_nil(value) do
    value
  end

  defp parse_to_float(value) do
    {float, _} = Float.parse(value)
    float
  end

  def force_update_job(netsuite_project_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_job(netsuite_project_id, update_data)
      error -> {:error, error}
    end
  end

  def force_update_customer(netsuite_customer_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_customer(netsuite_customer_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_customer(netsuite_customer_id, update_data)
      error -> {:error, error}
    end
  end

  def force_update_contact(hubspot_contact_id, update_data) do
    with {:ok, %{status: 200}} <-
           HubspotApi.update_contact(hubspot_contact_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_contact(hubspot_contact_id, update_data)
      error -> {:error, error}
    end
  end

  def force_update_deal(hubspot_deal_id, update_data) do
    with {:ok, %{status: 200}} <-
           HubspotApi.update_deal(hubspot_deal_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_deal(hubspot_deal_id, update_data)
      error -> {:error, error}
    end
  end

  def get_copper_employees() do
    Repo.all(
      from(p in CopperApi.Schemas.People,
        join: o in CopperApi.Schemas.Opportunity,
        on: o.primary_contact_id == p.copper_id,
        where: p.contact_type_id == 808_736,
        select: [
          p.first_name,
          p.last_name,
          p.address["street"],
          p.address["city"],
          p.address["state"],
          p.address["postal_code"],
          p.emails,
          p.phone_numbers,
          o.custom_fields
        ]
      )
    )
    |> Enum.map(fn [fin, ln, street, city, state, zip, emails, phone_numbers, cf] ->
      [
        fin,
        ln,
        street,
        city,
        state,
        zip,
        (emails |> List.first())["email"],
        (phone_numbers |> List.first())["number"],
        (cf
         |> Enum.find(fn %{"custom_field_definition_id" => custom_field_definition_id} ->
           custom_field_definition_id == 273_328
         end))["value"]
        |> (fn
              nil -> nil
              date -> TimeApi.from_unix(date) |> Timex.format!("{0M}/{0D}/{YYYY}")
            end).(),
        (cf
         |> Enum.find(fn %{"custom_field_definition_id" => custom_field_definition_id} ->
           custom_field_definition_id == 273_329
         end))["value"]
        |> (fn
              nil -> nil
              date -> TimeApi.from_unix(date) |> Timex.format!("{0M}/{0D}/{YYYY}")
            end).()
      ]
    end)
    |> List.insert_at(0, [
      "First Name",
      "Last Name",
      "Street",
      "City",
      "State",
      "Zip",
      "Email",
      "Phone Number",
      "Start Date",
      "Employees Last Day"
    ])
    |> InfoTech.write_to_csv("copper_employees_v1")
  end

  def get_netsuite_project_as_json(id) do
    import Ecto.Query

    Repo.all(from(j in NetsuiteApi.Project, where: j.netsuite_project_id == ^id))
    |> List.first()
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> {k |> Atom.to_string(), v} end)
    |> Enum.into(%{})
  end

  def the_omni_join() do
    import Ecto.Query

    from(hsd in HubspotApi.Deal,
      join: nsp in NetsuiteApi.Project,
      on: hsd.hubspot_deal_id == nsp.custentity_skl_hs_dealid,
      join: hso in HubspotApi.Owner,
      on: hsd.hubspot_owner_id == hso.hubspot_owner_id,
      select: {hsd.hubspot_deal_id, hso.hubspot_owner_id, nsp.netsuite_project_id}
    )
    |> Repo.all()
  end

  def get_all_netsuite_projects_join_hubspot_deals() do
    import Ecto.Query

    from(nsp in NetsuiteApi.Project,
      join: hsd in HubspotApi.Deal,
      on: hsd.hubspot_deal_id == nsp.custentity_skl_hs_dealid
    )
    |> Repo.all()
  end

  def get_all_hubspot_deals_join_netsuite_projects() do
    import Ecto.Query

    from(hsd in HubspotApi.Deal,
      join: nsp in NetsuiteApi.Project,
      on: hsd.hubspot_deal_id == nsp.custentity_skl_hs_dealid
    )
    |> Repo.all()
  end

  def remaining_netsuite_records_to_get_copper_files_for_hubspot_ids() do
    InfoTech.read_csv()
    |> Enum.map(fn r -> {r["HubSpot Deal ID"], r["Homeowner Email (Primary)"]} end)
  end

  def remaining_netsuite_records_to_get_copper_files_for_copper_ids() do
    test_netsuite_find_in_copper_by_email()
  end

  def netsuite_copper_missing_stuff_with_hubspot_ids() do
    [

    ]
  end

  def netsuite_copper_missing_stuff() do

  end

  def test_netsuite_find_in_copper_by_email() do
    import Ecto.Query

    netsuite_copper_missing_stuff()

    query =
      from(o in CopperApi.Schemas.Opportunity,
        join: p in CopperApi.Schemas.People,
        on: o.primary_contact_id == p.copper_id,
        select: {o.copper_id, p.emails}
      )

    Repo.all(query)
    |> Enum.map(fn {op_id, emails} -> {op_id, (emails |> List.first())["email"]} end)
    |> Enum.filter(fn {_op_id, email} -> Enum.member?(netsuite_copper_missing_stuff(), email) end)
  end

  def test_merge_copper_ids_and_hubspot_ids_on_email() do
    list_a = remaining_netsuite_records_to_get_copper_files_for_copper_ids()

    list_b = remaining_netsuite_records_to_get_copper_files_for_hubspot_ids()

    Enum.map(list_a, fn {copper_id, c_email} ->
      {copper_id, Enum.find(list_b, fn {_hubspot_id, h_email} -> c_email == h_email end)}
    end)
    |> Enum.map(fn {copper_id, {hubspot_id, email}} -> [copper_id, hubspot_id, email] end)
  end

  def read_hubspot_deal_csv() do
    csv =
      "./hubspot-crm-exports-all-deals-2021-12-14.csv"
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.to_list()

    Enum.map(csv, fn [
                       a,
                       b,
                       c,
                       d,
                       e,
                       f,
                       g,
                       h,
                       i,
                       j,
                       k,
                       l,
                       m,
                       n,
                       o,
                       p,
                       q,
                       r,
                       s,
                       t,
                       u,
                       v,
                       w,
                       x,
                       y,
                       z,
                       aa,
                       ab,
                       ac,
                       ad,
                       ae,
                       af,
                       ag,
                       ah,
                       ai,
                       aj,
                       ak,
                       al,
                       am,
                       an,
                       ao,
                       ap,
                       aq,
                       ar,
                       as,
                       at,
                       au,
                       av,
                       aw,
                       ax,
                       ay,
                       az,
                       ba,
                       bb,
                       bc_,
                       bd,
                       be,
                       bf,
                       bg,
                       bh,
                       bi,
                       bj,
                       bk,
                       bl,
                       bm,
                       bn,
                       bo,
                       bp,
                       bq,
                       br,
                       bs,
                       bt,
                       bu,
                       bv,
                       bw,
                       bx,
                       by,
                       bz,
                       ca,
                       cb,
                       cc,
                       cd,
                       ce,
                       cf,
                       cg,
                       ch,
                       ci,
                       cj,
                       ck,
                       cl,
                       cm,
                       cn,
                       co,
                       cp,
                       cq,
                       cr,
                       cs,
                       ct,
                       cu,
                       cv,
                       cw,
                       cx,
                       cy,
                       cz,
                       da,
                       db,
                       dc,
                       dd,
                       de,
                       df,
                       dg,
                       dh,
                       di,
                       dj,
                       dk,
                       dl,
                       dm,
                       dn,
                       do_,
                       dp,
                       dq,
                       dr,
                       ds,
                       dt,
                       du,
                       dv,
                       dw,
                       dx,
                       dy,
                       dz,
                       ea,
                       eb,
                       ec,
                       ed,
                       ee,
                       ef,
                       eg,
                       eh,
                       ei,
                       ej,
                       ek,
                       el,
                       em,
                       en,
                       eo,
                       ep,
                       eq,
                       er,
                       es,
                       et,
                       eu,
                       ev,
                       ew,
                       ex,
                       ey,
                       ez,
                       fa,
                       fb
                     ] ->
      %{
        "Deal ID" => a,
        "Site Survey Scheduled" => b,
        "Design Notes" => c,
        "Array Type" => d,
        "Cancelled at" => e,
        "Closed Won Reason" => f,
        "Annual contract value" => g,
        "Sales Area" => h,
        "Last Modified Date" => i,
        "Taxes included" => j,
        "Sighten Contract Interest Rate" => k,
        "Postal Code" => l,
        "State/Region" => m,
        "Proposal URL" => n,
        "Pipeline" => o,
        "Closing Accuracy" => p,
        "Weighted amount in company currency" => q,
        "Usage Note (kWh)" => r,
        "Processed at" => s,
        "Proposal Module Model" => t,
        "Netsuite Project Synced" => u,
        "Next step" => v,
        "S/S Rep" => w,
        "# of Smart Therms" => x,
        "Estimated Usage in First Year" => y,
        "Adders / Promises" => z,
        "Manager VA (Used)" => aa,
        "Campaign of last booking in meetings tool" => ab,
        "Sighten Contract Term Length" => ac,
        "Proposal Efficiency Equipment" => ad,
        "Forecast probability" => ae,
        "Netsuite Project Id" => af,
        "Time to Close (HH:mm:ss)" => ag,
        "Close Date" => ah,
        "Deal Type" => ai,
        "Ecommerce deal" => aj,
        "Proposal Module Size" => ak,
        "Financial status" => al,
        "Buyer accepts marketing" => am,
        "Enerflo Id" => an,
        "Number of times contacted" => ao,
        "Number of Sales Activities" => ap,
        "Recurring revenue deal type" => aq,
        "Design Feedback Notes" => ar,
        "Deal Split Added" => as,
        "Original Source Type" => at,
        "Forecast amount" => au,
        "Base PPW" => av,
        "Cancel Reason" => aw,
        "Utility Company " => ax,
        "Medium of last booking in meetings tool" => ay,
        "Tax price" => az,
        "Name" => ba,
        "Create Date" => bb,
        "Cancel reason" => bc_,
        "Date of last meeting booked in meetings tool" => bd,
        "Proposal Battery Model" => be,
        "City" => bf,
        "APPROVED (INTERNAL)" => bg,
        "Designer" => bh,
        "Closed-Lost / NI / DQ Reason" => bi,
        "Estimated Monthly Production Average" => bj,
        "Annual recurring revenue" => bk,
        "Copper Opportunity Id" => bl,
        "Netsuite Project Synced Test" => bm,
        "Subtotal price" => bn,
        "Utility Account Number" => bo,
        "Landing site" => bp,
        "Processing method" => bq,
        "Deal owner" => br,
        "Currency" => bs,
        "Last Activity Date" => bt,
        "Next Activity Date" => bu,
        "Proposal Inverter Size" => bv,
        "Utility Account Name" => bw,
        "Proposal Battery Count" => bx,
        "Source of last booking in meetings tool" => by,
        "Owner Assigned Date" => bz,
        "System production in first year" => ca,
        "Source name" => cb,
        "System Size (w)" => cc,
        "Install Area" => cd,
        "HOA - Name & Contact" => ce,
        "Solar Offset" => cf,
        "Shipment IDs" => cg,
        "Total weight" => ch,
        "Finance Fees" => ci,
        "Deal Stage" => cj,
        "Proposal Created Date" => ck,
        "Fulfillment status" => cl,
        "Install Date" => cm,
        "Inverter Count" => cn,
        "Number of Associated Contacts" => co,
        "Original Source Data 1" => cp,
        "Weighted amount" => cq,
        "Total Amount" => cr,
        "Cancel Date" => cs,
        "Total contract value" => ct,
        "Recurring revenue inactive reason" => cu,
        "Original Source Data 2" => cv,
        "Contact Owner" => cw,
        "Last Name" => cx,
        "Last Contacted" => cy,
        "Referring site" => cz,
        "Deal probability" => da,
        "HubSpot Team" => db,
        "Approved Date (Internal)" => dc,
        "Closed-Lost Date" => dd,
        "Country/Region" => de,
        "Deal Name" => df,
        "Premise Number" => dg,
        "Total PPW" => dh,
        "Closing / Customer Notes" => di,
        "Average Roof Pitch" => dj,
        "Mobile Phone Number" => dk,
        "Panel Tilt" => dl,
        "Order number" => dm,
        "Amount" => dn,
        "Discount savings" => do_,
        "Priority" => dp,
        "Date of Initial Sit" => dq,
        "Street Address" => dr,
        "Tags" => ds,
        "Estimated Utility Bill ($/month)" => dt,
        "Usage Source" => du,
        "Cart token" => dv,
        "Total line items price" => dw,
        "Abandoned cart URL" => dx,
        "Manager VA (Alotted)" => dy,
        "Monthly recurring revenue" => dz,
        "Sighten Site ID" => ea,
        "Token" => eb,
        "Design Accuracy" => ec,
        "First Name" => ed,
        "Phone Number" => ee,
        "Proposal Inverter Model" => ef,
        "Cash Price" => eg,
        "Module count" => eh,
        "Proposal Array Count" => ei,
        "Email" => ej,
        "Deal Description" => ek,
        "Recurring revenue inactive date" => el,
        "Adders PPW" => em,
        "Forecast category" => en,
        "Recurring revenue amount" => eo,
        "Site Survey Completed" => ep,
        "Lead Source" => eq,
        "Amount in company currency" => er,
        "Trenching Distance (ft)" => es,
        "System On Date" => et,
        "Finance Type" => eu,
        "Source store" => ev,
        "Date Sighten Contract Signed" => ew,
        "Checkout token" => ex,
        "Associated Company ID" => ey,
        "Associated Company" => ez,
        "Associated Contact IDs" => fa,
        "Associated Contacts" => fb
      }
    end)
  end

  def read_csv() do
    csv =
      "./ProjectInformationMissingResults248.csv"
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.to_list()

    headers = csv |> List.first()

    Enum.map(csv, fn [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p] ->
      %{
        "#{headers |> Enum.at(0)}" => a,
        "#{headers |> Enum.at(1)}" => b,
        "#{headers |> Enum.at(2)}" => c,
        "#{headers |> Enum.at(3)}" => d,
        "#{headers |> Enum.at(4)}" => e,
        "#{headers |> Enum.at(5)}" => f,
        "#{headers |> Enum.at(6)}" => g,
        "#{headers |> Enum.at(7)}" => h,
        "#{headers |> Enum.at(8)}" => i,
        "#{headers |> Enum.at(9)}" => j,
        "#{headers |> Enum.at(10)}" => k,
        "#{headers |> Enum.at(11)}" => l,
        "#{headers |> Enum.at(12)}" => m,
        "#{headers |> Enum.at(13)}" => n,
        "#{headers |> Enum.at(14)}" => o,
        "#{headers |> Enum.at(15)}" => p
      }
    end)
  end

  def count_of_retryable_oban_groups(:list) do
    import Ecto.Query

    query =
      from(j in Oban.Job,
        where: j.state == "retryable",
        group_by: j.worker,
        select: {j.worker, count(j.id), max(j.attempted_at)},
        order_by: [desc: max(j.attempted_at)]
      )

    Repo.all(query)
  end

  def count_of_completed_oban_groups(:list) do
    import Ecto.Query

    query =
      from(j in Oban.Job,
        where: j.state == "completed",
        group_by: j.worker,
        select: {j.worker, count(j.id), max(j.attempted_at)},
        order_by: [desc: max(j.attempted_at)]
      )

    Repo.all(query)
  end

  def query_retryable_oban_jobs() do
    import Ecto.Query

    query = from(j in Oban.Job, where: j.state == "retryable")

    Repo.all(query)
  end

  def query_completed_oban_jobs() do
    import Ecto.Query

    query = from(j in Oban.Job, where: j.state == "completed")

    Repo.all(query)
  end

  def query_oban() do
    import Ecto.Query

    query = from(j in Oban.Job)

    Repo.all(query)
  end

  def get_opportunity_ids() do
    import Ecto.Query

    query =
      from(o in CopperApi.Schemas.Opportunity,
        select: [o.copper_id, o.name, o.custom_fields],
        where: o.status == "Won"
      )

    CopperApi.Queries.execute_query(query)
    |> Task.async_stream(fn [copper_id, name, custom_fields] ->
      [
        copper_id,
        name,
        (custom_fields
         |> Enum.find(fn cf -> cf["custom_field_definition_id"] == 495_424 end))["value"]
      ]
    end)
    |> Stream.map(fn {:ok, el} -> el end)
    |> Enum.to_list()
  end

  def write_to_json(json_string, file_name) do
    File.touch("#{file_name}.json")

    File.write("#{file_name}.json", json_string)
  end

  @doc """
  Creates IT equipment.

  ## Examples

      iex> add_it_equipment(%{field: value})
      {:ok, %ItEquipment{}}

      iex> add_it_equipment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_it_equipment() do
    args = %{
      "brand" => "Apple",
      "serial_number" => "serial_number",
      "model_number" => "model_number",
      "model_name" => "model_name"
    }

    InfoTech.ItEquipment.new(args)
    |> Repo.insert()
  end

  def add_it_equipment(args) when is_map(args) do
    InfoTech.ItEquipment.new(args)
    |> Repo.insert()
  end

  def add_it_equipment(attrs) do
    alias InfoTech.ItEquipment

    %ItEquipment{}
    |> ItEquipment.changeset(attrs)
    |> Repo.insert()
  end

  def get_equipment() do
    Repo.get(InfoTech.ItEquipment, 1)
  end

  def add_it_receipt() do
    args = %{
      "vendor" => "Amazon",
      "item_cost" => 4.99,
      "item_tax" => 4.99 * 0.065,
      "item_cost_with_tax" => 4.99 + 4.99 * 0.065,
      "item_receipt_file" => nil
    }

    InfoTech.ItReceipt.new(args)
    |> Repo.insert()
  end

  def add_it_receipt(args) when is_map(args) do
    InfoTech.ItReceipt.new(args)
    |> Repo.insert()
  end

  def get_receipt() do
    Repo.get(InfoTech.ItReceipt, 1)
  end

  def add_it_checkout_form() do
    args = %{
      "employee_first_name" => "nathan",
      "employee_last_name" => "casados",
      "checkout_date" => DateTime.now!("Etc/UTC") |> DateTime.truncate(:second),
      "checkin_date" => DateTime.now!("Etc/UTC") |> DateTime.truncate(:second)
    }

    InfoTech.ItCheckoutForm.new(args)
    |> Repo.insert()
  end

  def add_it_checkout_form(args) when is_map(args) do
    InfoTech.ItCheckoutForm.new(args)
    |> Repo.insert()
  end

  def get_checkout_form() do
    Repo.get(InfoTech.ItCheckoutForm, 1)
  end

  def add_receipt_to_equipment(
        %InfoTech.ItReceipt{} = receipt,
        %InfoTech.ItEquipment{} = equipment
      ) do
    equipment
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:it_receipts, [receipt | equipment.it_receipts])
    |> Repo.update()
  end

  def add_checkout_form_to_equipment(
        %InfoTech.ItCheckoutForm{} = checkout_form,
        %InfoTech.ItEquipment{} = equipment
      ) do
    equipment
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:it_checkout_forms, [checkout_form | equipment.it_checkout_forms])
    |> Repo.update()
  end

  def find_oban_jobs_by_hubspot_id(hubspot_id) do
    Repo.all(Oban.Job) |> Enum.filter(fn o -> o.args["objectId"] == hubspot_id end)
  end

  @spec write_to_csv([[any]], String.t()) :: :ok
  def write_to_csv(array_of_arrays, title) do
    File.touch("#{title}.csv")
    file = File.open!("#{title}.csv", [:write, :utf8])

    array_of_arrays
    |> CSV.encode()
    |> Enum.each(&IO.write(file, &1))
  end

  def find_oban_job_by_hubspot_id(hubspot_id) do
    Repo.all(Oban.Job)
    |> Enum.filter(fn oban_job -> oban_job.args["objectId"] == hubspot_id end)
  end

  def oban_see_jobs() do
    import Ecto.Query
    Repo.all(from(j in Oban.Job, select: j, order_by: [desc: j.id]))
  end

  def oban_see_jobs_paginated(opts \\ []) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(_, [] = opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(:retryable, opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, where: j.state == "retryable", order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(:available, opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, where: j.state == "available", order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(:executing, opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, where: j.state == "executing", order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(:cancelled, opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, where: j.state == "cancelled", order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_paginated_by_state(:discarded, opts) do
    import Ecto.Query

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(j in Oban.Job, select: j, where: j.state == "discarded", order_by: [desc: j.id])
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def oban_see_jobs_scheduled_mst() do
    Repo.all(Oban.Job)
    |> Enum.map(fn j ->
      {_, updated_thing} =
        Map.get_and_update!(j, :scheduled_at, fn scheduled ->
          {scheduled, scheduled |> TimeApi.to_mst()}
        end)

      updated_thing
    end)
  end

  def oban_count_of_jobs_group_by_worker() do
    import Ecto.Query
    Repo.all(from(j in Oban.Job, select: {j.worker, count(j.id)}, group_by: j.worker))
  end

  def oban_get_job_by_id(oban_job_id) do
    Repo.get!(Oban.Job, oban_job_id)
  end

  def oban_drain_sales_webhooks_queue_with_scheduled_with_recursion() do
    Oban.drain_queue(queue: :skyline_sales, with_scheduled: true, with_recursion: true)
  end

  def oban_drain_operations_webhooks_queue_with_scheduled_with_recursion() do
    Oban.drain_queue(queue: :skyline_operations, with_scheduled: true, with_recursion: true)
  end
end
