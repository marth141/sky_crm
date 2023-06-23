defmodule CopperApi.LegacyLeads do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect leads from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.Lead
  alias CopperApi.Queries
  import Ex2ms

  def list_leads_ets() do
    :ets.select(:copper_leads_legacy, match_all_without_view_state())
  end

  def list_leads() do
    Lead.read()
  end

  def fetch_ets(lead_id) do
    [{_key, lead}] = :ets.lookup(:copper_leads_legacy, lead_id)
    lead
  end

  def fetch(lead_id) do
    Queries.Leads.by_copper_id(lead_id) |> Queries.execute_query() |> List.first()
  end

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  def list_unassigned_leads_today() do
    :ets.select(:copper_leads_legacy, match_unassigned_leads())
  end

  def match_unassigned_leads() do
    fun do
      {key, lead, assignee_id} when key != :view_state and assignee_id == nil -> lead
    end
  end

  def match_all_leads() do
    fun do
      {key, lead, _assignee_id} when key != :view_state -> lead
    end
  end

  def get_count_of_unassigned_leads() do
    fetch_value_from_view_state(:count_of_unassigned_leads)
  end

  def get_count_of_assigned_leads() do
    fetch_value_from_view_state(:count_of_assigned_leads)
  end

  def get_leads_for_user_id(user_id) do
    :ets.select(:copper_leads_legacy, match_on_leads_for_user_id(user_id))
  end

  def match_on_leads_for_user_id(user_id) do
    fun do
      {key, task, assignee_id} when key != :view_state and assignee_id == ^user_id -> task
    end
  end

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      # module genserver will call
      __MODULE__,
      # init params
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    tid = :ets.new(:copper_leads_legacy, [:named_table, :set, :public, read_concurrency: true])
    :ets.insert(:copper_leads_legacy, {:view_state, default_view_state()})
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_legacy, state) do
    set_refreshing_status()
    refresh_legacy()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    set_loading_status()
    refresh_legacy()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  # Private Helpers

  defp set_loading_status() do
    CopperApi.StatusServer.set_collector_status(__MODULE__, "LOADING")
  end

  defp set_refreshing_status() do
    CopperApi.StatusServer.set_collector_status(__MODULE__, "REFRESHING")
  end

  defp set_live_status() do
    CopperApi.StatusServer.set_collector_status(__MODULE__, "LIVE")
  end

  defp insert_view_state_to_ets(key, value) when is_atom(key) do
    old_view_state = fetch_view_state()
    view_state = Map.put(old_view_state, key, value)
    :ets.insert(:copper_leads_legacy, {:view_state, view_state})
  end

  defp fetch_value_from_view_state(key) do
    view_state = fetch_view_state()
    Map.get(view_state, key)
  end

  def fetch_view_state() do
    [{_key, view_state}] = :ets.lookup(:copper_leads_legacy, :view_state)
    view_state
  end

  def insert_or_update_postgres(item) do
    case Queries.Leads.by_copper_id(item.copper_id) |> Queries.execute_query() |> List.first() do
      nil -> Lead.create(item)
      existing -> existing
    end
    |> Lead.update(item)
  end

  def insert_to_ets(%Lead{id: id} = lead) do
    :ets.insert(:copper_leads_legacy, {id, lead})
  end

  defp default_view_state,
    do: %{
      count_of_unassigned_leads: 0,
      count_of_assigned_leads: 0,
      count_of_leads_by_status: %{},
      count_of_leads_by_date: %{}
    }

  defp refresh_legacy() do
    years = legacy_years()

    Task.async_stream(
      years,
      fn year ->
        year_list =
          stream_leads_from_copper(year)
          |> Enum.chunk_every(100)

        {
          Enum.each(year_list, fn chunk ->
            Repo.insert_all(Lead, chunk,
              on_conflict: :replace_all,
              conflict_target: :copper_id
            )
          end),
          year,
          "Leads"
        }
        |> IO.inspect()
      end,
      timeout: 600_000
    )
    |> Stream.run()

    current_date = TimeApi.today()
    insert_view_state_to_ets(:current_date, current_date)
    set_live_status()
    Messaging.publish("CopperApi", :copper_leads_legacy_updated)
    set_live_status()
    IO.puts("\n \n ======= Copper Legacy Leads Refreshed ======= \n \n")
    schedule_poll_legacy()
    :ok
  end

  defp schedule_poll_legacy do
    Process.send_after(self(), :refresh_legacy, :timer.hours(24))
  end

  defp legacy_years() do
    2016..2020
  end

  defp stream_leads_from_copper(year) do
    CopperApi.stream_leads(
      TimeApi.start_of_year(year),
      TimeApi.end_of_year(year)
    )
  end
end
