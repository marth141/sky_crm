defmodule CopperApi.People do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect people from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.People
  alias CopperApi.Queries
  import Ex2ms

  def list_people_ets() do
    :ets.select(:copper_people, match_all_without_view_state())
  end

  def list_people() do
    People.read()
  end

  def fetch_ets(people_id) do
    [{_key, people}] = :ets.lookup(:copper_people, people_id)
    people
  end

  def fetch(people_id) do
    if(is_nil(people_id)) do
      nil
    else
      result = Queries.People.by_copper_id(people_id) |> List.first()

      case result do
        nil ->
          Task.async(fn -> CopperApi.get_person(people_id) end)
          |> Task.await(60000)
          |> insert_or_update_postgres()

        _ ->
          result
      end
    end
  end

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
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
    tid = :ets.new(:copper_people, [:named_table, :set, :public, read_concurrency: true])
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    set_refreshing_status()
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    set_loading_status()
    refresh_cache()
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

  def fetch_view_state() do
    [{_key, view_state}] = :ets.lookup(:copper_people, :view_state)
    view_state
  end

  def insert_to_ets(%People{id: id} = lead) do
    :ets.insert(:copper_people, {id, lead})
  end

  defp insert_or_update_postgres(item) do
    case Queries.People.by_copper_id(item.copper_id) |> List.first() do
      nil -> People.create(item)
      existing -> existing
    end
    |> People.update(item)
  end

  def refresh_cache() do
    stream_people_from_copper()
    |> Task.async_stream(&insert_or_update_postgres/1)
    |> Stream.run()

    Messaging.publish("CopperApi", :copper_people_updated)
    set_live_status()
    IO.puts("\n \n ======= Copper People Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.minutes(10))
  end

  defp stream_people_from_copper() do
    CopperApi.stream_people(
      TimeApi.start_of_year(2016),
      TimeApi.today()
    )
  end
end
