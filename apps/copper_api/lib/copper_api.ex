defmodule CopperApi do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Documentation for `CopperApi`.

  This module is used for performing some actions with the Copper API.

  Overall, this is a Copper API Wrapper and this should have most of the border functions.
  """
  alias CopperApi.Schemas.ActivityType
  alias CopperApi.Schemas.Task, as: CopperTask
  alias CopperApi.Schemas.Opportunity, as: CopperOpp
  alias CopperApi.Schemas.Lead, as: CopperLead
  alias CopperApi.Schemas.Activity, as: CopperActivity
  alias CopperApi.Schemas.Pipeline
  alias CopperApi.Schemas.CustomFieldDefinition
  alias CopperApi.Schemas.User, as: CopperUser
  alias CopperApi.Schemas.People, as: CopperPeople
  alias CopperApi.Schemas.CustomerSource
  alias CopperApi.Paginator
  alias CopperApi.Client, as: CopperClient

  def topic(), do: inspect(__MODULE__)

  def subscribe, do: Messaging.subscribe(topic())

  def publish(message),
    do: Messaging.publish(topic(), message)

  def unsubscribe(),
    do: Messaging.unsubscribe(topic())

  def get_activities_for_customer() do
    CopperApi.Client.post("activities/search", %{
      "parent" => %{"id" => "16956954", "type" => "opportunity"},
      "page_size" => 200,
      "page_number" => 1
    })
  end

  def get_tasks_for_customer() do
    CopperApi.Client.post("tasks/search", %{
      "opportunity_ids" => ["16956954"],
      "page_size" => 200,
      "page_number" => 1
    })
  end

  def search_opportunities(opts \\ []) do
    page_number = Keyword.get(opts, :page_number, nil)
    page_size = Keyword.get(opts, :page_size, nil)
    sort_by = Keyword.get(opts, :sort_by, nil)
    sort_direction = Keyword.get(opts, :sort_direction, nil)
    name = Keyword.get(opts, :name, nil)
    assignee_ids = Keyword.get(opts, :assignee_ids, nil)
    status_ids = Keyword.get(opts, :status_ids, nil)
    pipeline_ids = Keyword.get(opts, :pipeline_ids, nil)
    pipeline_stage_ids = Keyword.get(opts, :pipeline_stage_ids, nil)
    company_ids = Keyword.get(opts, :company_ids, nil)
    tags = Keyword.get(opts, :tags, nil)
    followed = Keyword.get(opts, :followed, nil)
    minimum_monetary_value = Keyword.get(opts, :minimum_monetary_value, nil)
    maximum_monetary_value = Keyword.get(opts, :maximum_monetary_value, nil)
    minimum_interaction_count = Keyword.get(opts, :minimum_interaction_count, nil)
    maximum_interaction_count = Keyword.get(opts, :maximum_interaction_count, nil)
    minimum_close_date = Keyword.get(opts, :minimum_close_date, nil)
    maximum_close_date = Keyword.get(opts, :maximum_close_date, nil)
    minimum_interaction_date = Keyword.get(opts, :minimum_interaction_date, nil)
    maximum_interaction_date = Keyword.get(opts, :maximum_interaction_date, nil)
    minimum_stage_change_date = Keyword.get(opts, :minimum_stage_change_date, nil)
    maximum_stage_change_date = Keyword.get(opts, :maximum_stage_change_date, nil)
    minimum_created_date = Keyword.get(opts, :minimum_created_date, nil)
    maximum_created_date = Keyword.get(opts, :maximum_created_date, nil)
    minimum_modified_date = Keyword.get(opts, :minimum_modified_date, nil)
    maximum_modified_date = Keyword.get(opts, :maximum_modified_date, nil)
    custom_fields = Keyword.get(opts, :custom_fields, nil)

    with {:ok, opportunities} <-
           CopperApi.Client.post("opportunities/search", %{
             "page_number" => page_number,
             "page_size" => page_size,
             "sort_by" => sort_by,
             "sort_direction" => sort_direction,
             "name" => name,
             "assignee_ids" => assignee_ids,
             "status_ids" => status_ids,
             "pipeline_ids" => pipeline_ids,
             "pipeline_stage_ids" => pipeline_stage_ids,
             "company_ids" => company_ids,
             "tags" => tags,
             "followed" => followed,
             "minimum_monetary_value" => minimum_monetary_value,
             "maximum_monetary_value" => maximum_monetary_value,
             "minimum_interaction_count" => minimum_interaction_count,
             "maximum_interaction_count" => maximum_interaction_count,
             "minimum_close_date" => minimum_close_date,
             "maximum_close_date" => maximum_close_date,
             "minimum_interaction_date" => minimum_interaction_date,
             "maximum_interaction_date" => maximum_interaction_date,
             "minimum_stage_change_date" => minimum_stage_change_date,
             "maximum_stage_change_date" => maximum_stage_change_date,
             "minimum_created_date" => minimum_created_date,
             "maximum_created_date" => maximum_created_date,
             "minimum_modified_date" => minimum_modified_date,
             "maximum_modified_date" => maximum_modified_date,
             "custom_fields" => custom_fields
           }) do
      opportunities
    end
  end

  @doc """
  Checks if a copper opportunity is SkyFam
  """
  def check_if_in_skyfam(opportunity_id) do
    with {:ok, opportunity} <- CopperApi.get_opportunity(opportunity_id) do
      if opportunity.pipeline_id == CopperApi.Queries.Get.pipeline_id_by_name("SKYFAM") do
        {:ok, :is_skyfam}
      else
        {:ok, :is_not_skyfam}
      end
    else
      _error -> {:error, "Could not determine if SKYFAM or not"}
    end
  end

  @doc """
  Retrieves an opportunity by id from Copper and stores it in Postgres
  """
  def get_opportunity(opportunity_id) do
    with {:ok, resp} <- CopperApi.Client.get("opportunities/#{opportunity_id}") do
      {:ok,
       resp.body
       |> CopperApi.Schemas.Opportunity.new()
       |> CopperApi.Schemas.Opportunity.changeset()
       |> CopperApi.Schemas.Opportunity.create()
       |> Repo.preload(:primary_contact)}
    end
  end

  @doc """
  Deletes a specified Copper Webhook by id
  """
  def delete_webhooks(webhook_ids) do
    Enum.each(webhook_ids, fn webhook_id -> CopperApi.Client.del("webhooks/#{webhook_id}") end)
  end

  @doc """
  Updates a copper opportunity from a given update request
  """
  def update_opportunity_record(
        %CopperApi.Schemas.UpdateOpportunityRequest{
          copper_id: copper_id,
          custom_fields: custom_fields
        } = _request
      ) do
    CopperApi.Client.put(
      "opportunities/#{copper_id}",
      %{"custom_fields" => custom_fields}
    )
  end

  @doc """
  Updates a copper opportunity from a given Copper ID and Map containing
  properties to be updated.
  """
  def update_opportunity_record(
        copper_id,
        properties_map
      ) do
    CopperApi.Client.put(
      "opportunities/#{copper_id}",
      properties_map
    )
  end

  @doc """
  Creates an copper opportunity with a given create opportunity request
  """
  def create_opportunity_record(%CopperApi.Schemas.CreateOpportunityRequest{} = request) do
    CopperApi.Client.post(
      "opportunities",
      request |> Map.from_struct()
    )
  end

  @doc """
  Creates a copper people record
  """
  def create_people_record(%CopperApi.Schemas.CreatePersonRequest{} = request) do
    with {:ok, %{status: 200} = resp} <-
           CopperApi.Client.post(
             "people",
             request |> Map.from_struct()
           ) do
      {:ok, resp}
    else
      {:ok, %{body: %{"message" => "Person email address conflict"}, status: 422}} ->
        {:error, "Copper person already exists"}
    end
  end

  @doc """
  Updates a copper people record
  """
  def update_people_record(%CopperApi.Schemas.People{copper_id: copper_id} = person) do
    with {:ok, %{status: 200} = resp} <-
           CopperApi.Client.put(
             "people/#{copper_id}",
             person |> Map.delete(:__meta__) |> Map.delete(:__struct__)
           ) do
      {:ok, resp.body |> CopperApi.Schemas.People.new()}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Lists users in Copper
  """
  def list_users() do
    with {:ok, %Tesla.Env{status: 200, body: body}} <-
           CopperClient.post("users/search", %{page_size: 200}) do
      body
      |> Enum.map(&CopperUser.new/1)
    end
  end

  @doc """
  Lists activities in Copper
  """
  def list_activities(
        start_time,
        end_time,
        copper_id
      ) do
    stream_activities(
      start_time,
      end_time,
      copper_id
    )
    |> Enum.to_list()
  end

  @doc """
  Gets a list of activities from copper as a stream
  """
  def stream_activities(
        start_time,
        end_time,
        copper_id
      ) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "activities/search",
      results_per_page: 200,
      first_page: 1,
      minimum_activity_date: start_time_unix,
      maximum_activity_date: end_time_unix,
      activity_types: [%{id: copper_id, category: "user"}]
    })
    |> Stream.map(fn {:ok, activity_response} -> CopperActivity.new(activity_response) end)
  end

  @doc """
  Lists copper leads
  """
  def list_leads(
        start_time,
        end_time
      ) do
    stream_leads(
      start_time,
      end_time
    )
    |> Enum.to_list()
  end

  @doc """
  Gets a list of leads from copper as a stream
  """
  def stream_leads(
        start_time,
        end_time
      ) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "leads/search",
      results_per_page: 200,
      first_page: 1,
      minimum_created_date: start_time_unix,
      maximum_created_date: end_time_unix,
      pipeline_ids: nil,
      status_ids: nil
    })
    |> Stream.map(fn {:ok, lead_response} -> CopperLead.new(lead_response) end)
  end

  @doc """
  Lists copper leads
  """
  def list_tasks(
        start_time,
        end_time
      ) do
    stream_tasks(
      start_time,
      end_time
    )
    |> Enum.to_list()
  end

  @doc """
  Gets a list of tasks from copper as a stream
  """
  def stream_tasks(
        start_time,
        end_time
      ) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "tasks/search",
      results_per_page: 200,
      first_page: 1,
      minimum_created_date: start_time_unix,
      maximum_created_date: end_time_unix,
      pipeline_ids: nil,
      status_ids: nil
    })
    |> Stream.map(fn {:ok, task_response} -> CopperTask.new(task_response) end)
  end

  @doc """
  Gets a list of opportunities from copper with a given start time and end time
  """
  def list_opportunities_install_date(start_time, end_time) do
    stream_opportunities(start_time, end_time) |> Enum.to_list()
  end

  @doc """
  Gets a stream of opportunities from copper with a given start time and end time
  """
  def stream_opportunities_install_date(start_time, end_time) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "opportunities/search",
      results_per_page: 200,
      first_page: 1,
      minimum_created_date: start_time_unix,
      maximum_created_date: end_time_unix,
      pipeline_ids: nil,
      status_ids: nil
    })
    |> Stream.map(fn {:ok, opportunity_response} -> CopperOpp.new(opportunity_response) end)
  end

  @doc """
  Gets a list of opportunities from Copper
  """
  def list_opportunities(start_time, end_time) do
    stream_opportunities(start_time, end_time) |> Enum.to_list()
  end

  @doc """
  Gets a stream of opportunities from Copper
  """
  def stream_opportunities(start_time, end_time) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "opportunities/search",
      results_per_page: 200,
      first_page: 1,
      minimum_created_date: start_time_unix,
      maximum_created_date: end_time_unix,
      pipeline_ids: nil,
      status_ids: nil
    })
    |> Stream.map(fn {:ok, opportunity_response} -> CopperOpp.new(opportunity_response) end)
  end

  @doc """
  Gets a list of people from Copper
  """
  def list_people(start_time, end_time) do
    stream_people(start_time, end_time) |> Enum.to_list()
  end

  @doc """
  Gets a stream of people from Copper
  """
  def stream_people(start_time, end_time) do
    {start_time_unix, end_time_unix} = TimeApi.datetime_period_to_unix(start_time, end_time)

    Paginator.stream(%{
      url: "people/search",
      results_per_page: 200,
      first_page: 1,
      minimum_created_date: start_time_unix,
      maximum_created_date: end_time_unix,
      pipeline_ids: nil,
      status_ids: nil
    })
    |> Stream.map(fn {:ok, people_response} -> CopperPeople.new(people_response) end)
  end

  @doc """
  Gets a person from Copper and stores them in postgres

  Can use an id or an email address.
  """
  def get_person(people_id) when is_number(people_id) do
    with {:ok, %Tesla.Env{status: 200, body: body}} <- CopperClient.get("people/#{people_id}") do
      {:ok,
       body
       |> CopperPeople.new()
       |> CopperPeople.changeset()
       |> CopperPeople.create()}
    end
  end

  def get_person(%{"emails" => [email | _tail]} = _arg) when is_map(email) do
    with {:ok, %Tesla.Env{status: 200, body: body}} <-
           CopperClient.post("people/search", %{"emails" => [email["email"]]}) do
      {:ok,
       body
       |> List.last()
       |> CopperPeople.new()
       |> CopperPeople.changeset()
       |> CopperPeople.create()}
    end
  end

  def get_person(%{"emails" => [email | _tail]} = _arg) when is_binary(email) do
    with {:ok, %Tesla.Env{status: 200, body: body}} <-
           CopperClient.post("people/search", %{"emails" => [email]}) do
      {:ok,
       body
       |> List.last()
       |> CopperPeople.new()
       |> CopperPeople.changeset()
       |> CopperPeople.create()}
    end
  end

  def get_person(%{"emails" => []} = arg) when is_map(arg) do
    {:error, "No person possesses this email"}
  end

  @doc """
  Gets a list of pipelines from Copper
  """
  def list_pipelines() do
    with {:ok, %Tesla.Env{status: 200, body: body}} <- CopperClient.get("pipelines") do
      body
      |> Enum.map(&Pipeline.new/1)
    end
  end

  @doc """
  Gets a list of customer sources from Copper
  """
  def list_customer_sources() do
    with {:ok, %Tesla.Env{status: 200, body: body}} <- CopperClient.get("customer_sources") do
      body
      |> Enum.map(&CustomerSource.new/1)
    end
  end

  @doc """
  Gets a list of activity types from Copper
  """
  def list_activity_types() do
    with {:ok, %Tesla.Env{status: 200, body: body}} <- CopperClient.get("activity_types") do
      body
      # build metadata struc
      |> Map.values()
      |> List.flatten()
      |> Enum.map(&ActivityType.new/1)
    end
  end

  @doc """
  Gets a list of custom field definitions from Copper
  """
  def list_custom_fields() do
    with {:ok, %Tesla.Env{status: 200, body: body}} <-
           CopperClient.get("custom_field_definitions") do
      body
      |> Enum.map(&CustomFieldDefinition.new/1)
    end
  end

  @doc """
  Used to get the files for a copper record
  """
  def get_files_for(:opportunity, id) do
    CopperClient.get("/opportunities/#{id}/files")
  end
end
