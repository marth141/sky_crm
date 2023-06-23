defmodule InfoTech.CopperHubspotMunger do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ Github)

  This module was used for migrating copper data to Hubspot data and is no
  longer necessary.

  Basically mapped things from a Copper object to a Hubspot object and spat out
  a CSV.

  That CSV was uploaded to Hubspot and we've been working fine since.

  No real need for this thing.
  """
  import Ecto.Query

  alias CopperApi.Schemas.{
    Opportunity
  }

  def convert_leads_to_contacts do
    File.touch("copper_leads_to_hs_contacts.csv")
    file = File.open!("copper_leads_to_hs_contacts.csv", [:write, :utf8])

    _query =
      from(l in CopperApi.Schemas.Lead,
        where: not is_nil(l.email),
        select: [
          l.first_name,
          l.last_name,
          l.email,
          l.details,
          l.assignee_id,
          l.status,
          l.customer_source_id,
          l.address,
          l.phone_numbers,
          l.custom_fields,
          l.copper_id
        ]
      )
      |> CopperApi.Queries.execute_query()
      |> Task.async_stream(fn
        [
          first_name,
          last_name,
          email,
          details,
          assignee_id,
          status,
          customer_source_id,
          address,
          phone_numbers,
          custom_fields,
          copper_id
        ] ->
          first_name =
            if(is_nil(first_name),
              do: first_name,
              else: first_name |> String.replace("\t", "") |> String.replace(";", " ")
            )

          last_name =
            if(is_nil(last_name),
              do: last_name,
              else: last_name |> String.replace("\t", "") |> String.replace(";", " ")
            )

          contact_email =
            if(is_nil(email), do: nil, else: email |> Map.get("email") |> String.replace(";", " "))

          assignee_email = CopperApi.Queries.Get.copper_user_name_from_copper_id(assignee_id)

          customer_source = customer_source_id |> get_lead_source()

          street_address =
            if(is_nil(address) or Map.get(address, "street") == nil,
              do: "",
              else:
                address
                |> Map.get("street")
                |> String.replace("\t", "")
                |> String.replace(";", " ")
            )

          city =
            if(is_nil(address) or Map.get(address, "city") == nil,
              do: "",
              else:
                address |> Map.get("city") |> String.replace("\t", "") |> String.replace(";", " ")
            )

          state =
            if(is_nil(address) or Map.get(address, "state") == nil,
              do: "",
              else:
                address
                |> Map.get("state")
                |> String.replace("\t", "")
                |> String.replace(";", " ")
            )

          postal_code =
            if(is_nil(address) or Map.get(address, "postal_code") == nil,
              do: "",
              else:
                address
                |> Map.get("postal_code")
                |> String.replace("\t", "")
                |> String.replace(";", " ")
            )

          country =
            if(is_nil(address) or Map.get(address, "country") == nil,
              do: "",
              else:
                address
                |> Map.get("country")
                |> String.replace("\t", "")
                |> String.replace(";", " ")
            )

          phone_number =
            if(phone_numbers == [],
              do: nil,
              else:
                phone_numbers
                |> List.first()
                |> Map.get("number")
                |> String.replace(";", " ")
                |> String.replace("\t", " ")
            )

          on_title_deed_of_home =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "On Title/ Deed of home"
            )

          household_income =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "household Income above $40k?"
            )

          leds =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Need LEDs?")
            |> (fn word -> if(word == "Not Sure", do: "No", else: word) end).()

          need_thermostat =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "Need Smart Thermostat?"
            )
            |> (fn word -> if(word == "Not Sure", do: "No", else: word) end).()

          electric_company =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "Electric Company"
            )

          utility_company =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "Utility Company"
            )

          utility_company =
            if(utility_company == nil and electric_company != nil,
              do: electric_company,
              else: utility_company
            )

          sales_area =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("**Sales Area")

          install_area =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Install Area")

          referred_by =
            custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("Referred by")

          status_final =
            if(status != nil and String.contains?(status, "DQ - "), do: "DQ", else: status)
            |> (fn word ->
                  if(word != nil and String.match?(word, ~r/[0-9] - /),
                    do: word |> String.replace(~r/[0-9] - /, ""),
                    else: word
                  )
                end).()
            |> (fn word ->
                  case word do
                    "Texted" ->
                      "Attempted"

                    "Send to Doors" ->
                      "Aged"

                    "Call Back" ->
                      "Connected"

                    "Contacted" ->
                      "Connected"

                    "Qualified" ->
                      "Connected"

                    "Appt Scheduled" ->
                      "Call Scheduled"

                    "Current Customer" ->
                      "DQ"

                    "Returned" ->
                      "DQ"

                    "Not interested" ->
                      "Not Interested"

                    "Unqualified" ->
                      "DQ"

                    _ ->
                      word
                  end
                end).()

          dq_reason =
            if(status != nil and String.contains?(status, "DQ - "),
              do: String.replace(status, "DQ - ", ""),
              else: ""
            )
            |> (fn word -> if(word == "COVID -19", do: "COVID-19", else: word) end).()

          details_clean =
            if(is_nil(details),
              do: details,
              else: details |> String.replace("\t", "") |> String.replace(";", " ")
            )

          prosperworks_url =
            "https://app.prosperworks.com/auth/auto_login?redirect_url=https%3A%2F%2Fapp.prosperworks.com%2Fcompanies%2F157251%2Fapp%23%2Flead%2F#{copper_id}&use_active_session=1"

          [
            first_name,
            last_name,
            contact_email,
            details_clean,
            assignee_email,
            customer_source,
            status_final,
            dq_reason,
            street_address,
            city,
            state,
            postal_code,
            country,
            phone_number,
            on_title_deed_of_home,
            household_income,
            leds,
            need_thermostat,
            utility_company,
            sales_area,
            install_area,
            referred_by,
            prosperworks_url
          ]
      end)
      |> Stream.map(fn {:ok, item} -> item end)
      |> Enum.to_list()
      |> List.insert_at(0, [
        "first_name",
        "last_name",
        "email",
        "notes",
        "contact_owner",
        "lead_source",
        "status",
        "dq_reason",
        "street_address",
        "city",
        "state",
        "postal_code",
        "country",
        "phone_number",
        "homeowner",
        "taxable_income_>_$40k",
        "led",
        "therm",
        "utility_company",
        "sales_area",
        "install_area",
        "referred_by",
        "prosperworks_url"
      ])
      |> CSV.encode()
      |> Enum.each(&IO.write(file, &1))
  end

  # if customer lifecycle -> deal stage = "closed-won"

  def fetch_opp() do
    from(o in Opportunity,
      where: o.copper_id == 23_883_086,
      preload: [:tasks]
    )
    |> Repo.one()
  end

  def fetch_people_and_opportunities_and_tasks do
    from(o in CopperApi.Schemas.Opportunity, as: :opportunity)
    |> where([o], o.pipeline_id != 539_501)
    |> where([o], o.pipeline_id != 334_827)
    |> preload([:primary_contact, :tasks, :activities])
    |> Repo.all()
  end

  def convert_people_to_hs_contacts do
    File.touch("copper_people_to_hs_contact.csv")
    file = File.open!("copper_people_to_hs_contact.csv", [:write, :utf8])

    fetch_people_and_opportunities_and_tasks()
    |> Task.async_stream(fn
      %CopperApi.Schemas.Opportunity{
        primary_contact: p,
        tasks: tasks
      } = o ->
        deal_stage =
          pipeline_and_stage(
            CopperApi.Queries.Get.pipeline_name_by_id(o.pipeline_id),
            tasks
          )

        pipeline = CopperApi.Queries.Get.pipeline_name_by_id(o.pipeline_id)

        %{
          "email_final" => unless(is_nil(p), do: get_email_from_list(p.emails), else: nil),
          "city" => unless(is_nil(p), do: p.address |> get_city, else: nil),
          "country_region" => unless(is_nil(p), do: p.address |> get_country, else: nil),
          "lead_source" => o.customer_source_id |> get_lead_source,
          "mobile_phone_number" =>
            unless(is_nil(p), do: p.phone_numbers |> get_phone_number, else: nil),
          "phone_number" => unless(is_nil(p), do: p.phone_numbers |> get_phone_number, else: nil),
          "state" => unless(is_nil(p), do: p.address |> get_state, else: nil),
          "street_address" => unless(is_nil(p), do: p.address |> get_street, else: nil),
          "postal_code" => unless(is_nil(p), do: p.address |> get_postal_code(), else: nil),
          "closed_date" =>
            unless(is_nil(o.close_date),
              do:
                if(deal_stage != "Closed-Won",
                  do: nil,
                  else: o.close_date |> TimeApi.from_unix() |> Timex.format!("{M}-{D}-{YYYY}")
                ),
              else: o.close_date
            ),
          "system_size" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("System Size")
            |> calc_w_from_kw(),
          "amount" => o.monetary_value,
          "first_name" => unless(is_nil(p), do: p.first_name |> clean_string, else: nil),
          "last_name" => unless(is_nil(p), do: p.last_name |> clean_string, else: nil),
          "notes" => "",
          "contact_owner" =>
            CopperApi.Queries.Get.from_custom_fields_setter_specialist(o.custom_fields),
          "lead_status" =>
            pipeline
            |> (fn pipeline ->
                  case pipeline do
                    "Customer Life-Cycle" ->
                      "Closed Deal"

                    "Solar Consultations" ->
                      "Open deal"
                  end
                end).(),
          "utility_company" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "Utility Company"
            ),
          "sales_area" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Sales Area"),
          "install_area" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Install Area"),
          "referred_by" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Referred by"),
          "prosperworks_url" =>
            "https://app.prosperworks.com/auth/auto_login?redirect_url=https%3A%2F%2Fapp.prosperworks.com%2Fcompanies%2F157251%2Fapp%23%2Fdeal%2F#{o.copper_id}&use_active_session=1"
        }
    end)
    |> Stream.map(fn {:ok, item} -> item end)
    |> Enum.to_list()
    |> convert_to_csv()
    |> IO.inspect(label: "csv")
    |> Enum.each(&IO.write(file, &1))
  end

  def convert_people_opportunity_and_tasks_to_hs_deals do
    File.touch("copper_people_opportunities_and_tasks_to_hs_deals.csv")
    file = File.open!("copper_people_opportunities_and_tasks_to_hs_deals.csv", [:write, :utf8])

    fetch_people_and_opportunities_and_tasks()
    |> Task.async_stream(fn
      %CopperApi.Schemas.Opportunity{
        primary_contact: p,
        tasks: tasks
      } = o ->
        deal_stage =
          pipeline_and_stage(
            CopperApi.Queries.Get.pipeline_name_by_id(o.pipeline_id),
            tasks
          )

        pipeline = CopperApi.Queries.Get.pipeline_name_by_id(o.pipeline_id)

        fulfillment_pipeline_stage =
          CopperApi.Queries.Get.pipeline_stage_name_by_id(
            o.pipeline_id,
            o.pipeline_stage_id
          )
          |> get_hubspot_deal_stage_from_copper_pipeline_stage()

        lead_status =
          pipeline
          |> (fn pipeline ->
                case pipeline do
                  "Customer Life-Cycle" ->
                    "Closed Deal"

                  "Solar Consultations" ->
                    "Open deal"
                end
              end).()

        %{
          "email" => unless(is_nil(p), do: get_email_from_list(p.emails), else: nil),
          "deal_name" =>
            unless(is_nil(p),
              do: "#{p.first_name |> clean_string} #{p.last_name |> clean_string} Deal",
              else: nil
            ),
          "deal_stage" =>
            unless(lead_status == "Closed Deal",
              do: deal_stage,
              else:
                if(o.status == "Lost" and pipeline == "Customer Life-Cycle",
                  do: "Canceled",
                  else: fulfillment_pipeline_stage
                )
            ),
          "hubspot_owner_id" =>
            CopperApi.Queries.Get.copper_user_name_from_copper_id(o.assignee_id),
          "contact_owner" =>
            CopperApi.Queries.Get.from_custom_fields_setter_specialist(o.custom_fields),
          "city" => unless(is_nil(p), do: p.address |> get_city, else: nil),
          "country_region" => unless(is_nil(p), do: p.address |> get_country, else: nil),
          "first_name" => unless(is_nil(p), do: p.first_name |> clean_string, else: nil),
          "install_area" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Install Area"),
          "last_name" => unless(is_nil(p), do: p.last_name |> clean_string, else: nil),
          "lead_source" => o.customer_source_id |> get_lead_source,
          "mobile_phone_number" =>
            unless(is_nil(p), do: p.phone_numbers |> get_phone_number, else: nil),
          "phone_number" => unless(is_nil(p), do: p.phone_numbers |> get_phone_number, else: nil),
          "sales_area" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("**Sales Area"),
          "state_region" => unless(is_nil(p), do: p.address |> get_state, else: nil),
          "street_address" => unless(is_nil(p), do: p.address |> get_street, else: nil),
          "utility_company" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
              "Utility Company"
            ),
          "postal_code" => unless(is_nil(p), do: p.address |> get_postal_code(), else: nil),
          "closed_date" =>
            unless(is_nil(o.close_date),
              do:
                if(deal_stage != "Closed-Won",
                  do: nil,
                  else: o.close_date |> TimeApi.from_unix() |> Timex.format!("{M}-{D}-{YYYY}")
                ),
              else: o.close_date
            ),
          "system_size" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("System Size")
            |> calc_w_from_kw(),
          "amount" => o.monetary_value,
          "lead_status" => lead_status,
          "deal_pipeline" =>
            pipeline
            |> (fn pipeline ->
                  case pipeline do
                    "Customer Life-Cycle" ->
                      "Fulfillment Pipeline"

                    "Solar Consultations" ->
                      "Sales Pipeline"
                  end
                end).(),
          "site_survey_completed" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name(
              "------------------SITE SURVEY COMPLETED------------------"
            )
            |> clean_date,
          "system_on" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("**System On")
            |> clean_date,
          "install_date" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name(
              "---------------------------INSTALL DATE---------------------------"
            )
            |> clean_date,
          "utility_account_number" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("Utility Account Number")
            |> clean_string,
          "hoa_name_+_hoa_contact_info" =>
            (fn ->
               hoa_name =
                 o.custom_fields
                 |> CopperApi.Queries.Get.from_custom_fields_value_where_name("HOA Name")

               hoa_contact_info =
                 o.custom_fields
                 |> CopperApi.Queries.Get.from_custom_fields_value_where_name("HOA Contact Info")

               "#{hoa_name} #{hoa_contact_info}" |> clean_string()
             end).(),
          "finance_type" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name("Finance Type"),
          "proposal_link" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("Proposal link"),
          "xcel_premise_number" =>
            o.custom_fields
            |> CopperApi.Queries.Get.from_custom_fields_value_where_name("Xcel Premise Number")
        }
    end)
    |> Stream.map(fn {:ok, item} -> item end)
    |> Enum.to_list()
    # |> Enum.filter(fn
    #   %{"email" => email} -> validate_email(email)
    # end)
    # |> Enum.chunk_every(20)
    # |> Enum.at(0)
    # |> Enum.filter(fn %{"hubspot_owner_id" => element} ->
    #   element !=
    #     nil
    # end)
    # |> Enum.filter(fn %{"amount" => element} ->
    #   element !=
    #     nil
    # end)
    # |> Enum.filter(fn %{"closed_date" => element} ->
    #   element !=
    #     nil
    # end)
    # |> Enum.filter(fn %{"deal_stage" => element} ->
    #   element ==
    #     "canceled"
    # end)
    |> convert_to_csv()
    |> IO.inspect(label: "csv")
    |> Enum.each(&IO.write(file, &1))
  end

  # def validate_email(nil) do
  #   nil
  # end

  # def validate_email(email) do
  #   EmailChecker.valid?(email)
  # end

  def clean_date(date) do
    unless(is_nil(date),
      do:
        date
        |> TimeApi.from_unix()
        |> Timex.format!("{M}-{D}-{YYYY}"),
      else: date
    )
  end

  def get_hubspot_deal_stage_from_copper_pipeline_stage(pipeline_name) do
    case pipeline_name do
      "0 Closed-Won" ->
        "Onboarding"

      "1 Onboarding" ->
        "Onboarding"

      "2 CADs & Engineering" ->
        "Design"

      "3 Net Meter App & Permitting" ->
        "Permitting/NMA"

      "4 Awaiting Installation" ->
        "Installation"

      "5 Installation/Funding" ->
        "Installation"

      "6 Multi-step Installation/Funding" ->
        "Installation"

      "7 Final Inspections" ->
        "Inspections"

      "8 Net-metering" ->
        "Net Metering"

      "9 System On" ->
        "System On"

      "10 Rebate Prep" ->
        "System On"

      "11 Project Completed" ->
        "System On"

      "12 On Hold" ->
        "On-Hold"

      "13 Service Tickets" ->
        "System On"

      _ ->
        "Closed Deal"
    end
  end

  def calc_w_from_kw(nil) do
    nil
  end

  def calc_w_from_kw(input_string) do
    try do
      input_string = String.replace(input_string, ~r/[a-z]|[A-Z]/, "")
      {number, _text} = Integer.parse(input_string)
      number * 1000
    rescue
      _ -> nil
    end
  end

  defp get_postal_code(nil) do
    nil
  end

  defp get_postal_code(address) do
    address |> Map.get("postal_code") |> clean_string()
  end

  defp get_street(nil) do
    nil
  end

  defp get_street(address) do
    address |> Map.get("street") |> clean_string()
  end

  defp get_state(nil) do
    nil
  end

  defp get_state(address) do
    address |> Map.get("state") |> clean_string()
  end

  defp get_country(nil) do
    nil
  end

  defp get_country(address) do
    address |> Map.get("country") |> clean_string()
  end

  defp get_city(nil) do
    nil
  end

  defp get_city(address) do
    address |> Map.get("city") |> clean_string()
  end

  defp get_phone_number(phone_numbers) do
    if(phone_numbers == [],
      do: nil,
      else:
        phone_numbers
        |> List.first()
        |> Map.get("number")
        |> clean_string()
    )
  end

  defp get_lead_source(customer_source_id) do
    if(is_nil(customer_source_id),
      do: customer_source_id,
      else: CopperApi.CustomerSource.fetch(customer_source_id) |> Map.get(:name)
    )
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Facebook - /),
            do: "Facebook",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Lead Genesis - Aged/),
            do: "Lead Genesis",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/YouTube - MN/),
            do: "YouTube",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Sunlynk - Aged/),
            do: "Sunlynk",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Bottom Feeder/),
            do: "Skyline Click Funnels",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/YouTube - Wyo/),
            do: "YouTube",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Inside Sales/),
            do: "Self-Gen",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/WaveSolar/),
            do: "Wave Solar",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Door to Door/),
            do: "Door2Door",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Closer Self Gen/),
            do: "Self-Gen",
            else: word
          )
        end).()
    |> (fn word ->
          if(word != nil and String.match?(word, ~r/Org Vans/),
            do: "Marketing Referral",
            else: word
          )
        end).()
  end

  defp pipeline_and_stage("Customer Life-Cycle", _tasks) do
    "Closed-Won"
  end

  defp pipeline_and_stage("Solar Consultations", tasks) do
    # Credit Approved - Pending Docs
    # Proposal Reviewed - Pending Approval
    # Design Complete - Pending Review
    # Closed-Lost
    dispositions =
      Enum.map(tasks, fn task ->
        CopperApi.Queries.Get.from_custom_fields_dropdowns_value_where_name(
          task.custom_fields,
          "Disposition"
        )
      end)

    cond do
      has_any_closed_task?(dispositions) -> "Closed-Lost"
      has_a_sat_task?(dispositions) -> "Proposal Reviewed - Pending Approval"
      true -> "Design Complete - Pending Review"
    end
  end

  defp has_any_closed_task?(dispositions) do
    Enum.any?(dispositions, fn d ->
      d in [
        "No Sit - Unqualified Lead",
        "No Sit - Cancelled - COVID-19",
        "Sat - Failed Credit"
      ]
    end)
  end

  defp has_a_sat_task?(dispositions) do
    Enum.any?(dispositions, fn
      disposition when disposition != nil ->
        String.contains?(disposition, "Sat")

      _anything_else ->
        false
    end)
  end

  defp clean_string(nil) do
    nil
  end

  defp clean_string(string) do
    string |> String.replace("\t", "") |> String.replace(";", "")
  end

  defp get_email_from_list([]) do
    nil
  end

  defp get_email_from_list([nil | _]) do
    nil
  end

  defp get_email_from_list([%{"email" => email} | _]) do
    email |> clean_string()
  end

  defp convert_to_csv([first_item | _rest] = items) do
    columns = Map.keys(first_item)

    Enum.map(items, fn item -> Map.values(item) end)
    |> List.insert_at(0, columns)
    |> CSV.encode()
  end

  def opportunities_and_people_as_contacts do
    _query =
      from(o in CopperApi.Schemas.Opportunity,
        join: p in CopperApi.Schemas.People,
        on: o.primary_contact_id == p.copper_id,
        select: [o.custom_fields, o.status, o.pipeline_id, o.pipeline_stage_id, p.emails]
      )
      |> CopperApi.Queries.execute_query()

    #   |> CSV.encode()

    # File.touch("opportunities.csv")
    # file = File.open!("opportunities.csv", [:write, :utf8])
    # query |> Enum.each(&IO.write(file, &1))

    # :ok
  end

  def opportunities_and_tasks do
    _query =
      from(o in CopperApi.Schemas.Opportunity,
        join: t in CopperApi.Schemas.Task,
        on:
          o.primary_contact_id ==
            fragment("""
            cast(c1.related_resource->>'id' as int)
            """),
        select: [o, t]
      )
      |> CopperApi.Queries.execute_query()
  end
end
