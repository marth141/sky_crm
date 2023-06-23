defmodule SkylineOperations do
  import Ecto.Query

  @moduledoc """
  Documentation for `SkylineOperations`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SkylineOperations.hello()
      :world

  """
  def hello do
    :world
  end

  def ship_to_sharepoint() do
    turn_restlet_to_csv_func = fn title, restlet -> turn_restlet_to_csv(title, restlet) end

    titles = [
      %SkylineOperations.SavedSearchRestlet{
        title: "Installs Funded by Month",
        link:
          "https://org.restlets.api.netsuite.com/app/site/hosting/restlet.nl?script=928&deploy=1",
        func: turn_restlet_to_csv_func
      }
    ]

    Enum.map(titles, fn %SkylineOperations.SavedSearchRestlet{
                          title: title,
                          link: restlet,
                          func: f
                        } ->
      f.(title, restlet)

      csv = File.read!("#{title}.csv")

      token = OnedriveApi.get_application_access_token()

      OnedriveApi.upload_a_csv_to_power_bi_files(
        token["access_token"],
        csv,
        title
      )
    end)
  end

  def turn_restlet_to_csv(title, restlet) do
    restlet = get_restlet(restlet)

    headers = restlet |> List.first() |> Map.keys()

    body =
      restlet
      |> Enum.map(fn obj ->
        Enum.map(obj, fn {_k, v} -> v end)
      end)

    array_of_arrays = body |> List.insert_at(0, headers)

    {InfoTech.write_to_csv(array_of_arrays, title), title}
  end

  def get_restlet(restlet) do
    {:ok, %{body: body}} = NetsuiteApi.Client.get_restlet(restlet)

    body
  end

  def send_finance_contract_signed_message(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.SendFinanceContractSignedMessage.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def find_all_completed_netsuite_projects() do
    import Ecto.Query

    from(p in NetsuiteApi.Project, where: not is_nil(p.custentity_skl_hs_dealid))
    |> Repo.all()
    |> Enum.map(fn p -> SkylineOperations.NetsuiteProjectStatus.get_project_status(p) end)
    |> Enum.filter(fn {_dates, status} -> status == "Completed" end)
    |> Enum.count()
  end

  def test_create_netsuite_case() do
    _incoming_case =
      %{
        "isDeleted" => "value",
        "objectId" => 823_945_250,
        "objectType" => "value",
        "objectTypeId" => "value",
        "portalId" => "value",
        "properties" => %{
          "closed_date" => %{
            "value" => "value"
          },
          "content" => %{
            "value" => "Test ticket from Hubspot to Netsuite Content"
          },
          "createdate" => %{
            "value" => "value"
          },
          "date_assigned" => %{
            "value" => "1645142400000"
          },
          "eta" => %{
            "value" => "value"
          },
          "hs_all_accessible_team_ids" => %{
            "value" => "value"
          },
          "hs_all_owner_ids" => %{
            "value" => "value"
          },
          "hs_all_team_ids" => %{
            "value" => "value"
          },
          "hs_created_by_user_id" => %{
            "value" => "value"
          },
          "hs_lastmodifieddate" => %{
            "value" => "value"
          },
          "hs_num_associated_companies" => %{
            "value" => "value"
          },
          "hs_object_id" => %{
            "value" => "value"
          },
          "hs_pipeline" => %{
            "value" => "value"
          },
          "hs_pipeline_stage" => %{
            "value" => "13033842"
          },
          "hs_ticket_id" => %{
            "value" => "value"
          },
          "hs_ticket_priority" => %{
            "value" => "HIGH"
          },
          "hs_updated_by_user_id" => %{
            "value" => "value"
          },
          "hs_user_ids_of_all_owners" => %{
            "value" => "value"
          },
          "hubspot_owner_assigneddate" => %{
            "value" => "1645214044094"
          },
          "hubspot_owner_id" => %{
            "value" => "value"
          },
          "hubspot_team_id" => %{
            "value" => "value"
          },
          "priority_type" => %{
            "value" => "value"
          },
          "subject" => %{
            "value" => "Test Hubspot to Netsuite Case Subject"
          },
          "ticket_requested_by" => %{
            "value" => "value"
          },
          "ticket_type" => %{
            "value" => "value"
          },
          "time_to_assign" => %{
            "value" => "value"
          },
          "time_to_close" => %{
            "value" => "value"
          }
        },
        "secondaryIdentifier" => "value",
        "version" => "value"
      }
      |> SkylineOperations.Jobs.HandleHubspotTicket.new()
      |> Oban.insert!()
  end

  def god_damn_map_query() do
    import Ecto.Query

    from(d in HubspotApi.Deal,
      select: [
        d.properties["street_address"],
        d.properties["city"],
        d.properties["state_region"],
        d.properties["zip"],
        d.properties["utility_company"],
        d.properties["dealname"],
        d.properties["phone_number"],
        d.properties["dealstage"],
        d.properties["closedate"],
        d.properties["hs_object_id"]
      ],
      where:
        not fragment("? ->> ? = ?", d.properties, "closedate", "") and
          (fragment("? ->> ? = ?", d.properties, "dealstage", "11444574") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13223683") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13223684") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13223685") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13223686") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13224022") or
             fragment("? ->> ? = ?", d.properties, "dealstage", "13224023"))
    )
    |> Repo.all()
  end

  def god_damn_map() do
    god_damn_map_query()
    |> Enum.map(fn [street, city, state, zip, utility, name, phone, dealstage, closedate, deal_id] ->
      street = if(is_nil(street), do: "", else: street)
      city = if(is_nil(city), do: "", else: city)
      state = if(is_nil(state), do: "", else: state)
      zip = if(is_nil(state), do: "", else: zip)
      address = [street, city, state, zip] |> Enum.join(",")
      hubspot_link = "https://app.hubspot.com/contacts/org/deal/#{deal_id}"

      [
        address,
        utility,
        name,
        phone,
        SkylineOperations.FulfillmentPipeline.dictionary()[dealstage],
        closedate |> TimeApi.parse_to_date() |> Timex.format!("{M}/{D}/{YYYY}"),
        hubspot_link
      ]
    end)
    |> List.insert_at(0, [
      "address",
      "utility",
      "name",
      "phone",
      "dealstage",
      "closedate",
      "hubspot_link"
    ])
    |> write_to_csv("hubspot_closed_stuff")
  end

  def god_damn_map_data() do
    god_damn_map_query()
    |> Task.async_stream(
      fn [
           street,
           city,
           state,
           zip,
           utility,
           name,
           phone,
           dealstage,
           closedate,
           deal_id
         ] ->
        street = if(is_nil(street), do: "", else: street)
        city = if(is_nil(city), do: "", else: city)
        state = if(is_nil(state), do: "", else: state)
        zip = if(is_nil(state), do: "", else: zip)
        address = [street, city, state, zip] |> Enum.join(",")
        hubspot_link = "https://app.hubspot.com/contacts/org/deal/#{deal_id}"

        try do
          with {:ok, %{lat: lat, lon: lon}} <-
                 Geocoder.call(
                   address: address,
                   key: Application.get_env(:geocoder, :worker)[:key],
                   timeout: :infinity
                 ) do
            %{
              "address" => address,
              "lat" => lat,
              "lon" => lon,
              "utility" => utility,
              "name" => name,
              "phone" => phone,
              "dealstage" => SkylineOperations.FulfillmentPipeline.dictionary()[dealstage],
              "closedate" =>
                closedate |> TimeApi.parse_to_date() |> Timex.format!("{M}/{D}/{YYYY}"),
              "hubspot_link" => hubspot_link,
              "deal_id" => deal_id
            }
          end
        catch
          _e -> {:error, "can't parse that"}
        end
      end,
      timeout: :infinity
    )
    |> Stream.filter(fn
      {:ok, {:error, _thing}} -> false
      _ -> true
    end)
    |> Stream.map(fn {:ok, thing} -> thing end)
    |> Stream.filter(fn el -> el != nil end)
  end

  @spec write_to_csv([[any]], String.t()) :: :ok
  def write_to_csv(array_of_arrays, title) do
    File.touch("#{title}.csv")
    file = File.open!("#{title}.csv", [:write, :utf8])

    array_of_arrays
    |> CSV.encode()
    |> Enum.each(&IO.write(file, &1))
  end

  def send_nps_score_to_netsuite(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.SendNPSScoreToNetsuite.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def handle_hubspot_ticket(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.HandleHubspotTicket.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def update_netsuite_customers_with_finance_fees_and_cash_price() do
    import Ecto.Query

    # HubspotApi.DealCollector.refresh_cache()

    Repo.all(
      from(d in HubspotApi.Deal,
        select: %{
          "hubspot_deal_id" => d.hubspot_deal_id,
          "netsuite_project_id" => d.properties["netsuite_project_id"],
          "netsuite_customer_id" => d.properties["netsuite_customer_id"],
          "properties" => d.properties
        }
      )
    )
    |> Enum.filter(fn d -> d["netsuite_project_id"] != nil end)
    |> Enum.map(fn %{
                     "netsuite_customer_id" => netsuite_customer_id,
                     "properties" => properties
                   } ->
      %{"netsuite_customer_id" => netsuite_customer_id, "properties" => properties}
    end)
    |> Task.async_stream(&try_update_netsuite_job_2/1, timeout: :infinity)
    |> Enum.to_list()
  end

  def update_netsuite_projects_with_finance_fees_and_cash_price() do
    import Ecto.Query

    # HubspotApi.DealCollector.refresh_cache()

    Repo.all(
      from(d in HubspotApi.Deal,
        select: %{
          "netsuite_project_id" => d.properties["netsuite_project_id"],
          "properties" => d.properties
        }
      )
    )
    |> Enum.filter(fn d -> d["netsuite_project_id"] != nil end)
    |> Task.async_stream(&try_update_netsuite_job_2/1, timeout: :infinity)
    |> Enum.to_list()
  end

  def try_update_netsuite_job_2(
        %{"properties" => properties, "netsuite_project_id" => netsuite_project_id} = arg
      ) do
    update = SkylineOperations.MigrateHubspotDealToNetsuiteProject.exec(properties)

    # {netsuite_project_id, update}
    # |> IO.inspect()

    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, update) do
      {:ok, "Updated Project #{netsuite_project_id}"}
      |> IO.inspect()
    else
      {:ok, %{status: 429}} ->
        try_update_netsuite_job_2(arg)

      {:ok, %{status: 404}} ->
        {:ok, "Project not found"}

      {:ok, %{body: body, status: 400}} ->
        body = Jason.decode!(body)

        case body do
          %{
            "o:errorDetails" => [
              %{
                "detail" =>
                  "Error while accessing a resource. Invalid url. Spaces are not allowed in the URL."
              }
            ]
          } ->
            {:ok, "Weird URL Error"}
            |> IO.inspect()

          _ ->
            {netsuite_project_id, body}
            |> IO.inspect()

            {:ok, {netsuite_project_id, body}}
        end
    end
  end

  def try_update_netsuite_job_2(
        %{"properties" => properties, "netsuite_customer_id" => netsuite_customer_id} = arg
      ) do
    update = SkylineOperations.MigrateHubspotDealToNetsuiteProject.exec(properties)

    # {netsuite_customer_id, update}
    # |> IO.inspect()

    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_customer(netsuite_customer_id, update) do
      {:ok, "Updated Customer #{netsuite_customer_id}"}
      |> IO.inspect()
    else
      {:ok, %{status: 429}} ->
        try_update_netsuite_job_2(arg)

      {:ok, %{status: 404}} ->
        {:ok, "Project not found"}

      {:ok, %{status: 405}} ->
        {:ok, "Weird 405 issue"}

      {:ok, %{body: body, status: 400}} ->
        body = Jason.decode!(body)

        case body do
          %{
            "o:errorDetails" => [
              %{
                "detail" =>
                  "Error while accessing a resource. Invalid url. Spaces are not allowed in the URL."
              }
            ]
          } ->
            {:ok, "Weird URL Error"}
            |> IO.inspect()

          _ ->
            {netsuite_customer_id, body}
            |> IO.inspect()

            {:ok, {netsuite_customer_id, body}}
        end
    end
  end

  def update_hubspot_with_netsuite_site_survey_approved_date(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.UpdateHubspotWithNetsuiteSiteSurveyApprovedDate.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def get_parent_customer_of_project(id) when is_integer(id) do
    import Ecto.Query

    try do
      [sub_customer_id] =
        Repo.all(
          from(p in NetsuiteApi.Project, where: p.netsuite_project_id == ^id, select: p.parent)
        )

      [sub_customer] =
        Repo.all(
          from(c in NetsuiteApi.Customer, where: c.netsuite_customer_id == ^sub_customer_id)
        )

      [parent_customer] =
        Repo.all(
          from(c in NetsuiteApi.Customer,
            where: c.netsuite_customer_id == ^sub_customer.parent
          )
        )

      %{"parent_id" => parent_customer.netsuite_customer_id, "sub_customer_id" => sub_customer_id}
    rescue
      _ -> %{"parent_id" => nil, "sub_customer_id" => nil}
    end
  end

  def get_parent_customer_of_project(project) when is_map(project) do
    import Ecto.Query

    try do
      id = project.netsuite_project_id

      [sub_customer_id] =
        Repo.all(
          from(p in NetsuiteApi.Project, where: p.netsuite_project_id == ^id, select: p.parent)
        )

      [sub_customer] =
        Repo.all(
          from(c in NetsuiteApi.Customer, where: c.netsuite_customer_id == ^sub_customer_id)
        )

      [parent_customer] =
        Repo.all(
          from(c in NetsuiteApi.Customer,
            where: c.netsuite_customer_id == ^sub_customer.parent
          )
        )

      %{"parent_id" => parent_customer.netsuite_customer_id, "sub_customer_id" => sub_customer_id}
    rescue
      _ -> %{"parent_id" => nil, "sub_customer_id" => nil}
    end
  end

  def update_all_projects_with_contact_sales_rep() do
    import Ecto.Query

    from(hsd in HubspotApi.Deal,
      join: nsp in NetsuiteApi.Project,
      on: hsd.hubspot_deal_id == nsp.custentity_skl_hs_dealid,
      join: hso in HubspotApi.Owner,
      on: hsd.contact_owner == hso.hubspot_owner_id,
      select: [
        nsp.netsuite_project_id,
        nsp.custentity_bb_home_owner_name_text,
        hso.email
      ]
    )
    |> Repo.all()
    |> Enum.map(fn [nspid, ho, email] ->
      %{"parent_id" => parent_id, "sub_customer_id" => _sub_cus_id} =
        get_parent_customer_of_project(nspid)

      employee =
        from(e in NetsuiteApi.Employee, where: e.email == ^email)
        |> Repo.all()
        |> List.first()

      if(is_nil(parent_id),
        do: [nspid, parent_id, ho, email],
        else:
          if(is_nil(employee),
            do: [nspid, parent_id, ho, nil],
            else: [nspid, parent_id, ho, employee.netsuite_employee_id]
          )
      )
    end)
    |> Enum.filter(fn [_a, b, _c, _d] -> b != nil end)
    |> Enum.filter(fn [_a, _b, _c, d] -> d != nil end)
    |> Task.async_stream(
      &try_and_update_sales_rep_on_job_and_customer/1,
      timeout: :infinity
    )
    |> Enum.to_list()
  end

  def update_all_projects_with_deal_sales_rep() do
    import Ecto.Query

    from(d in HubspotApi.Deal,
      join: p in NetsuiteApi.Project,
      on: d.hubspot_deal_id == p.custentity_skl_hs_dealid,
      join: o in HubspotApi.Owner,
      on: d.hubspot_owner_id == o.hubspot_owner_id,
      where: d.hubspot_deal_id == 8_102_737_283,
      select: [p.netsuite_project_id, p.custentity_bb_home_owner_name_text, o.email],
      order_by: [desc: p.netsuite_project_id]
    )
    |> Repo.all()
    |> Enum.map(fn [nspid, ho, email] ->
      %{"parent_id" => parent_id, "sub_customer_id" => _sub_cus_id} =
        get_parent_customer_of_project(nspid)

      employee =
        from(e in NetsuiteApi.Employee, where: e.email == ^email)
        |> Repo.all()
        |> List.first()

      if(is_nil(parent_id),
        do: [nspid, parent_id, ho, email],
        else:
          if(is_nil(employee),
            do: [nspid, parent_id, ho, nil],
            else: [nspid, parent_id, ho, employee.netsuite_employee_id]
          )
      )
    end)
    |> Enum.filter(fn [_a, b, _c, _d] -> b != nil end)
    |> Enum.filter(fn [_a, _b, _c, d] -> d != nil end)
    |> Task.async_stream(
      &try_and_update_sales_rep_on_job_and_customer/1,
      timeout: :infinity
    )
    |> Enum.to_list()
  end

  defp try_and_update_sales_rep_on_job_and_customer(
         [
           netsuite_project_id,
           netsuite_customer_id,
           _homeowner,
           employee_id
         ] = arg
       ) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_customer(netsuite_customer_id, %{
             "custentity_sk_sales_rep" => employee_id
           }),
         {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, %{
             "custentity_sk_sales_rep" => employee_id
           }) do
      {:ok, "Updated Sales Rep"}
    else
      {:ok, %{status: 429}} ->
        Process.sleep(60000)
        try_and_update_sales_rep_on_job_and_customer(arg)

      error ->
        {:error, error}
        |> IO.inspect()
    end
  end

  def the_omni_join() do
    import Ecto.Query

    from(hsd in HubspotApi.Deal,
      join: nsp in NetsuiteApi.Project,
      on: hsd.hubspot_deal_id == nsp.custentity_skl_hs_dealid,
      join: hso in HubspotApi.Owner,
      on: hsd.contact_owner == hso.hubspot_owner_id,
      select: [hsd, hso, nsp]
    )
    |> Repo.all()
  end

  def fetch_departments() do
    with {:ok, %{body: body}} <-
           NetsuiteApi.suiteql("""
           SELECT *
           FROM department
           ORDER BY id
           """) do
      (body |> Jason.decode!())["items"]
    end
  end

  def fetch_inside_sales_department() do
    with {:ok, %{body: body}} <-
           NetsuiteApi.suiteql("""
           SELECT *
           FROM department
           ORDER BY id
           """) do
      (body |> Jason.decode!())["items"]
      |> Enum.find(fn d -> d["name"] == "Inside Sales" end)
    end
  end

  def fetch_inside_sales_employees() do
    department = fetch_inside_sales_department()

    with {:ok, %{body: body}} <-
           NetsuiteApi.suiteql("""
           SELECT *
           FROM employee
           ORDER BY id
           """) do
      (body |> Jason.decode!())["items"]
      |> Enum.filter(fn d -> d["department"] == department["id"] end)
    end
  end

  def update_hubspot_with_netsuite_status(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.UpdateHubspotWithNetsuiteStatus.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def update_cancelled_job_from_hubspot_to_netsuite(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.UpdateCancelledJobFromHubspotToNetsuite.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def send_site_survey_completed_from_hubspot_to_netsuite(params) do
    with {:ok, oban_job} <-
           SkylineOperations.Jobs.SendSiteSurveyCompletedFromHubspotToNetsuite.new(params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def get_netsuite_hubspot_associations() do
    import Ecto.Query

    query =
      from(a in SkylineOperations.NetsuiteProjectHubspotDealAssociation,
        order_by: [desc: a.netsuite_project_id]
      )

    Repo.all(query)
  end

  @doc """
  Used for a one off csv export
  """
  def find_customers_of_list_of_projects(list) do
    list
    |> Task.async_stream(fn {hsid, nspid, name, netsuite_customer_id} ->
      with {:ok, %{body: body}} <- NetsuiteApi.get_customer(netsuite_customer_id),
           parent_id <- Jason.decode!(body)["parent"]["id"],
           {:ok, %{body: body}} <- NetsuiteApi.get_customer(parent_id),
           parent <- Jason.decode!(body) do
        [parent["custentity_bb_home_owner_primary_email"], name, nspid, hsid]
      end
    end)
    |> Stream.map(fn {:ok, item} -> item end)
    |> Enum.to_list()
    |> List.insert_at(0, [
      "Netsuite Customer Email",
      "Netsuite Customer Name",
      "Netsuite Project Id",
      "Hubspot Deal Id"
    ])
    |> write_to_csv("Netsuite Records Missing Hubspot ids and emails")
  end

  @doc """
  Used to feed in a list that contains hubspot and netsuite id pairs
  then associates the two. Might need to make some adjustments in
  the code for the pattern to match
  """
  def associate_list_of_hubspot_deals_with_netsuite_projects(list) do
    list
    |> Enum.chunk_every(100)
    |> Enum.map(fn chunk ->
      Process.sleep(11000)

      chunk
      |> Task.async_stream(
        fn {hubspot_deal_id, netsuite_project_id, _name} ->
          associate_hubspot_deal_with_netsuite_project(hubspot_deal_id, netsuite_project_id)
        end,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, item} -> item end)
      |> Enum.to_list()
    end)
    |> Enum.flat_map(fn chunk -> chunk end)
    |> Enum.map(fn {:ok, %{body: body, status: status}} -> {body, status} end)
  end

  @doc """
  Used to feed in a list that contains hubspot and netsuite id pairs
  then associates the two. Might need to make some adjustments in
  the code for the pattern to match
  """
  def associate_list_of_netsuite_projects_with_hubspot_deals(list) do
    list
    |> Task.async_stream(fn {hubspot_deal_id, netsuite_project_id, _name} ->
      associate_netsuite_project_with_hubspot_deal(netsuite_project_id, hubspot_deal_id)
    end)
    |> Enum.to_list()
  end

  @doc """
  Used to asociate a netsuite project with a hubspot deal

  Updates Netsuite

  ## Parameters

  *   `netsuite_project_id` The Netsuite Project (Job) ID to associate with the Hubspot Deal
  *   `hubspot_deal_id` The Hubspot Deal ID to associate with the Netsuite Project (Job)
  """
  def associate_netsuite_project_with_hubspot_deal(netsuite_project_id, hubspot_deal_id) do
    NetsuiteApi.update_job(netsuite_project_id, %{
      "custentity_skl_hs_dealid" => hubspot_deal_id
    })
  end

  @doc """
  Used to asociate a netsuite project with a hubspot deal

  Updates Hubspot

  ## Parameters

  *   `hubspot_deal_id` The Hubspot Deal ID to associate with the Netsuite Project (Job)
  *   `netsuite_project_id` The Netsuite Project (Job) ID to associate with the Hubspot Deal
  """
  def associate_hubspot_deal_with_netsuite_project(hubspot_deal_id, netsuite_project_id) do
    HubspotApi.update_deal(hubspot_deal_id, %{"netsuite_project_id" => netsuite_project_id})
  end

  @doc """
  Used to test creating a netsuite customer in from a Hubspot customer
  """
  def create_netsuite_customer_from_hubspot_deal(params) do
    SkylineOperations.Jobs.CreateNetsuiteCustomer.new(params)
    |> Oban.insert()
  end

  @doc """
  With a Hubspot Deal id, returns the deal with the listed properties from Hubspot

  Returns `{:ok, %HubspotApi.Deal{}}`

  ## Examples

      iex> SkylineOperations.get_hubspot_properties_for_netsuite(5568776798)
      {:ok, %HubspotApi.Deal{}}

  """
  def get_hubspot_properties_for_netsuite(deal_id) do
    HubspotApi.get_deal(deal_id, [
      "adders",
      "amount",
      "average_roof_pitch",
      "base_cost",
      "base_ppw",
      "city",
      "closing_notes",
      "dealname",
      "email",
      "finance_cost",
      "finance_type",
      "first_name",
      "hoa___name___contact",
      "hs_object_id",
      "install_area",
      "last_name",
      "lead_source",
      "mobile_phone_number",
      "module_count",
      "phone_number",
      "premise_number",
      "proposal_array_count",
      "proposal_battery_count",
      "proposal_battery_model",
      "proposal_efficiency_equipment",
      "proposal_inverter_model",
      "proposal_inverter_size",
      "proposal_module_model",
      "proposal_module_size",
      "proposal_url",
      "site_survey_scheduled",
      "state_region",
      "street_address",
      "system_size",
      "total_amount",
      "utility_account_name",
      "utility_account_number",
      "utility_company",
      "zip",
      "site_survey_completed",
      "ppw",
      "inverter_count",
      "panel_tilt",
      "trenching_distance",
      "array_type",
      "sighten_contract_interest_rate",
      "sighten_contract_term_length",
      "netsuite_project_id",
      "closedate",
      "hoa___name___contact",
      "finance_cost",
      "finance_fees_ppw",
      "sighten_site_id",
      "sighten_quote_id",
      "hubspot_owner_id",
      "cashback_amount",
      "eagleview",
      "household_size",
      "adders_goeverbright",
      "promises",
      "contact_owner",
      "referred_by"
    ])
  end
end
