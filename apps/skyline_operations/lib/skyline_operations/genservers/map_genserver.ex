defmodule SkylineOperations.MapGenserver do
  @moduledoc """
  Caches all Copper Tasks in memory and refreshes periodically notifying pub sub.
  """
  use GenServer
  import Ex2ms

  def read_ets() do
    :ets.select(:map_data, match_all_without_view_state())
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
    tid = :ets.new(:map_data, [:named_table, :set, :public, read_concurrency: true])
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  # Private Helpers

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  def fetch_view_state() do
    [{_key, view_state}] = :ets.lookup(:copper_tasks, :view_state)
    view_state
  end

  defp insert_to_ets(map_record) do
    :ets.insert(:map_data, {map_record["deal_id"], map_record})
  end

  def refresh_cache() do
    SkylineOperations.god_damn_map_data()
    |> Task.async_stream(&insert_to_ets/1)
    |> Stream.run()

    IO.puts("\n \n ======= Map Data Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.minutes(60))
  end
end
