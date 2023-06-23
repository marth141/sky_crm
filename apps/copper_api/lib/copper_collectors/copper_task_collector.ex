defmodule CopperApi.Tasks do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect tasks from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.Task, as: CTask
  alias CopperApi.Queries
  import Ex2ms

  def list_tasks_ets() do
    :ets.select(:copper_tasks, match_all_without_view_state())
  end

  def list_tasks() do
    CTask.read()
  end

  def fetch_ets(task_id) do
    [{_key, task, _assigned}] = :ets.lookup(:copper_tasks, task_id)
    task
  end

  def fetch(task_id) do
    Queries.Tasks.by_copper_id(task_id)
  end

  def list_solar_consultations_today() do
    solar_consultation_id = get_solar_consultation_copper_id()

    CTask.read()
    |> filter_by_custom_activity_type_id(solar_consultation_id)
    |> Enum.filter(fn %CTask{due_date: due_date} ->
      cond do
        due_date != nil ->
          :eq == Date.compare(due_date |> TimeApi.from_unix(), TimeApi.today())

        true ->
          false
      end
    end)
  end

  def get_tasks_by_user_id() do
    CTask.read()
    |> Enum.group_by(& &1.assignee_id)
  end

  def get_tasks_for_user_id(user_id) do
    :ets.select(:copper_tasks, match_on_tasks_for_user_id(user_id))
  end

  def match_on_tasks_for_user_id(user_id) do
    fun do
      {key, task, assignee_id} when key != :view_state and assignee_id == ^user_id -> task
    end
  end

  def get_count_of_solar_consultations_for_today() do
    fetch_value_from_view_state(:solar_consultations_today)
  end

  def get_count_of_solar_consultations_for_this_week do
    fetch_value_from_view_state(:solar_consultations_this_week)
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
    tid = :ets.new(:copper_tasks, [:named_table, :set, :public, read_concurrency: true])
    :ets.insert(:copper_tasks, {:view_state, default_view_state()})
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    set_refreshing_status()
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
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
    refresh_cache()
    # refresh_legacy()
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

  defp match_all_without_view_state() do
    fun do
      {key, value, _asignee_id} when key != :view_state -> value
    end
  end

  defp get_solar_consultation_copper_id() do
    CopperApi.ActivityType.list_activity_types()
    |> Enum.filter(fn %{name: name} ->
      name == "Solar Consultation"
    end)
    |> List.first()
    |> Map.get(:id)
  end

  defp filter_by_custom_activity_type_id(tasks, activity_type_id) do
    tasks
    |> Enum.filter(fn %CTask{custom_activity_type_id: custom_activity_type_id} ->
      custom_activity_type_id == activity_type_id
    end)
  end

  defp insert_view_state_to_ets(key, value) when is_atom(key) do
    old_view_state = fetch_view_state()
    view_state = Map.put(old_view_state, key, value)
    :ets.insert(:copper_tasks, {:view_state, view_state})
  end

  defp fetch_value_from_view_state(key) do
    view_state = fetch_view_state()
    Map.get(view_state, key)
  end

  def fetch_view_state() do
    [{_key, view_state}] = :ets.lookup(:copper_tasks, :view_state)
    view_state
  end

  def insert_to_ets(%CTask{id: id, assignee_id: assignee_id} = task) do
    :ets.insert(:copper_tasks, {id, task, assignee_id})
  end

  defp insert_or_update_postgres(item) do
    case Queries.Tasks.by_copper_id(item.copper_id) |> List.first() do
      nil -> CTask.create(item)
      existing -> existing
    end
    |> CTask.update(item)
  end

  defp default_view_state,
    do: %{
      solar_consultations_today: 0,
      solar_consultations_this_week: 0
    }

  def refresh_cache() do
    stream_tasks_from_copper()
    |> Stream.map(&insert_or_update_postgres/1)
    |> Stream.run()

    current_date = TimeApi.today()
    insert_view_state_to_ets(:current_date, current_date)
    set_live_status()
    Messaging.publish("CopperApi", :copper_tasks_updated)
    IO.puts("\n \n ======= Copper Tasks Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  def refresh_legacy() do
    years = legacy_years()

    Task.async_stream(
      years,
      fn year ->
        {
          stream_tasks_from_copper(year)
          |> Stream.map(&insert_or_update_postgres/1)
          |> Stream.run(),
          year,
          "Tasks"
        }
        |> IO.inspect()
      end,
      timeout: 600_000
    )
    |> Stream.run()

    current_date = TimeApi.today()
    insert_view_state_to_ets(:current_date, current_date)
    set_live_status()
    Messaging.publish("CopperApi", :copper_tasks_updated)
    IO.puts("\n \n ======= Copper Legacy Tasks Refreshed ======= \n \n")
    schedule_poll_legacy()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.minutes(10))
  end

  defp schedule_poll_legacy do
    Process.send_after(self(), :refresh_legacy, :timer.hours(24))
  end

  defp legacy_years() do
    2016..2020
  end

  defp current_year() do
    {integer, _} = TimeApi.today() |> Timex.format!("{YYYY}") |> Integer.parse()
    integer
  end

  defp stream_tasks_from_copper() do
    CopperApi.stream_tasks(
      TimeApi.start_of_year(current_year()),
      TimeApi.end_of_year(current_year())
    )
  end

  defp stream_tasks_from_copper(year) do
    CopperApi.stream_tasks(
      TimeApi.start_of_year(year),
      TimeApi.end_of_first_quarter(year)
    )
  end
end
