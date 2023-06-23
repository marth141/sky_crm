defmodule NetsuiteApi do
  @moduledoc """
  Documentation for `NetsuiteApi`.
  """

  import Ecto.Query

  @doc """
  Hello world.

  ## Examples

      iex> NetsuiteApi.hello()
      :world

  """
  def hello do
    :world
  end

  def get_opportunity() do
    NetsuiteApi.Client.get("/opportunity/123730")
  end

  def get_netsuite_list(list) do
    with {:ok, %{status: 200, body: body}} = NetsuiteApi.Client.get("/#{list}"),
         body <- Jason.decode!(body),
         items <- body["items"],
         items <- process_netsuite_list(list, items) do
      items
    else
      {:ok, resp} -> {:error, resp}
    end
  end

  defp process_netsuite_list(list, items) do
    Enum.map(items, fn item ->
      force_get_list_item(list, item)
    end)
  end

  defp force_get_list_item(list, item) do
    with {:ok, %{status: 200, body: body}} <-
           NetsuiteApi.Client.get("/#{list}/#{item["id"]}"),
         body <- Jason.decode!(body) do
      body
    else
      {:ok, %{status: 429}} ->
        force_get_list_item(list, item)

      {:ok, error} ->
        {:error, error}
    end
  end

  @doc """
  Updates a case in netsuite
  """
  def update_support_case(
        %NetsuiteApi.Case{netsuite_case_id: netsuite_case_id} = _netsuite_case,
        update
      ) do
    NetsuiteApi.Client.post("/supportCase/#{netsuite_case_id}", update)
  end

  @doc """
  Creates a case in netsuite
  """
  def create_support_case(netsuite_case) do
    NetsuiteApi.Client.post("/supportCase", netsuite_case)
  end

  def test_create_support_case() do
    test_case = %{
      "title" => "Test Case",
      "startDate" => "2022-02-04",
      "status" => "2",
      "subsidiary" => "1",
      "priority" => "3",
      "incomingMessage" =>
        "This is a test case, please disregard and please check with N before deleting",
      "startTime" => "12:57",
      "phone" => "18554759765",
      "customForm" => "-100",
      "company" => "67200",
      "email" => "@org",
      "assigned" => "4",
      "stage" => "OPEN",
      "profile" => "1"
    }

    NetsuiteApi.Client.post("/supportCase", test_case)
  end

  @doc """
  Used to get a case out of Netsuite
  """
  def get_support_case(support_case_id) do
    NetsuiteApi.Client.get("/supportCase/#{support_case_id}")
  end

  @doc """
  Used to get a customer out of Netsuite
  """
  def get_customer(customer_id) do
    NetsuiteApi.Client.get("/customer/#{customer_id}")
  end

  @doc """
  Used to get a job/project out of Netsuite
  """
  def get_job(job_id) do
    NetsuiteApi.Client.get("/job/#{job_id}")
  end

  @doc """
  Used to get a job/project out of the local postgres
  """
  def get_repo_job(netsuite_job_id: job_id) do
    Repo.all(from(p in NetsuiteApi.Project, where: p.netsuite_project_id == ^job_id))
  end

  def get_repo_job(hubspot_deal_id: hubspot_deal_id) do
    Repo.all(
      from(p in NetsuiteApi.Project, where: p.custentity_skl_hs_dealid == ^hubspot_deal_id)
    )
  end

  @doc """
  Used to update a Netsuite Customer
  """
  def update_customer(customer_id, params \\ %{}) do
    NetsuiteApi.Client.patch("/customer/#{customer_id}", params)
  end

  @doc """
  Used to update a Netsuite Job
  """
  def update_job(job_id, params \\ %{}) do
    NetsuiteApi.Client.patch("/job/#{job_id}", params)
  end

  @doc """
  Used to execute some SuiteQL
  """
  def suiteql(suiteql) do
    NetsuiteApi.Client.post_suiteql(
      params: %{
        "q" => suiteql
      }
    )
  end

  @doc """
  Used to define the `NetsuiteApi` topic for `:messaging`
  """
  def topic(), do: inspect(__MODULE__)

  @doc """
  Subscribes the process to the `:netsuite_api` process
  """
  def subscribe, do: Messaging.subscribe(topic())

  @doc """
  Publishes as message to the `NetsuiteApi` topic
  """
  def publish(message),
    do: Messaging.publish(topic(), message)

  @doc """
  Unsubscribes a process from `NetsuiteApi`
  """
  def unsubscribe(),
    do: Messaging.unsubscribe(topic())

  @doc """
  Streams in AHJ record from Netsuite
  """
  def stream_netsuite_authority_having_jurisdictions() do
    query = """
    SELECT *
    FROM customrecord_bb_auth_having_jurisdiction
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in Lead Sources from Netsuite
  """
  def stream_netsuite_lead_sources() do
    query = """
    SELECT *
    FROM customlist_skl_hs_lead_sources
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in Locations from Netsuite
  """
  def stream_netsuite_locations() do
    query = """
    SELECT *
    FROM Location
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every authority handling jurisdiction record from Netsuite
  """
  def stream_netsuite_authority_handling_jurisdictions() do
    query = """
    SELECT *
    FROM customrecord_bb_auth_having_jurisdiction
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every customer record from Netsuite
  """
  def stream_netsuite_customers() do
    query = """
    SELECT *
    FROM customer
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every employee from Netsuite
  """
  def stream_netsuite_employees() do
    query = """
    SELECT *
    FROM employee
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every project action from Netsuite
  """
  def stream_netsuite_project_actions() do
    query = """
    SELECT *
    FROM CUSTOMRECORD_BB_PROJECT_ACTION
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every project from Netsuite
  """
  def stream_netsuite_projects() do
    query = """
    SELECT *
    FROM job
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every state from Netsuite
  """
  def stream_netsuite_states() do
    query = """
    SELECT *
    FROM customrecord_bb_state
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every utility company from Netsuite
  """
  def stream_netsuite_utility_companies() do
    query = """
    SELECT *
    FROM customrecord_bb_utility_company
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Streams in every case from Netsuite
  """
  def stream_netsuite_cases() do
    query = """
    SELECT *
    FROM supportCase
    ORDER BY id
    """

    start = fn ->
      {:ok, %{body: body}} =
        NetsuiteApi.Client.post_suiteql(
          params: %{
            "q" => query
          }
        )

      body = body |> Jason.decode!()

      items = body["items"]

      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end

    next_item = fn
      state = {[], nil} -> {:halt, state}
      state = {[], _next} -> fetch_next_page(state, query)
      state -> pop_item(state)
    end

    stop = fn _state -> nil end

    Stream.resource(start, next_item, stop)
  end

  # For streaming in stuff via pagination
  defp fetch_page(next_page_url, query) do
    Process.sleep(333)

    {:ok, %{body: body}} =
      NetsuiteApi.Client.post_suiteql(
        url: next_page_url,
        params: %{
          "q" => query
        }
      )

    body = body |> Jason.decode!()

    items = body["items"]

    if body["links"] == nil do
      fetch_page(next_page_url, query)
    else
      next =
        (body["links"]
         |> Enum.filter(fn link -> link["rel"] == "next" end)
         |> List.first())["href"]

      {items, next}
    end
  end

  # For streaming in stuff via pagination
  defp fetch_next_page(state = {[], next_page}, query) do
    Process.sleep(5000)

    case fetch_page(next_page, query) do
      {_items, []} -> {:halt, state}
      {items, meta} -> pop_item({items, meta})
    end
  end

  # For streaming in stuff via pagination
  defp pop_item({[head | tail], next}) do
    new_state = {tail, next}
    {[head], new_state}
  end

  def force_update_job(netsuite_project_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_job(netsuite_project_id, update_data)
      {:ok, %{status: 400}} -> force_update_job(netsuite_project_id, update_data)
      error -> {:error, error}
    end
  end
end
