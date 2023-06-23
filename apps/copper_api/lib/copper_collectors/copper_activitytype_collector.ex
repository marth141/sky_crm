defmodule CopperApi.ActivityType do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect activitytypes from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.ActivityType, as: CopperActivity
  import Ex2ms

  def list_activity_types() do
    :ets.select(:copper_activity_types, match_all_without_view_state())
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
    tid = :ets.new(:copper_activity_types, [:named_table, :set, :public, read_concurrency: true])
    :ets.insert(:copper_activity_types, {:view_state, default_view_state()})
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
    try do
      refresh_cache()
      {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    rescue
      _e ->
        schedule_poll()
        {:noreply, state}
    end
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

  defp insert_to_ets(%CopperActivity{id: id} = activity_type) do
    :ets.insert(:copper_activity_types, {id, activity_type})
  end

  defp default_view_state,
    do: %{
      solar_consultations_today: 0,
      solar_consultations_this_week: 0
    }

  defp refresh_cache() do
    to_insert = fetch_all_activity_types_from_copper()
    Enum.each(to_insert, &insert_to_ets/1)

    Messaging.publish(
      "CopperApi",
      :copper_activity_types_updated
    )

    IO.puts("\n \n ======= Copper Activity Types Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.hours(24))
  end

  defp fetch_all_activity_types_from_copper() do
    CopperApi.list_activity_types()
  end
end
