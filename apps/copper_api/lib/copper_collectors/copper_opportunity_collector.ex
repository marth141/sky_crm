defmodule CopperApi.Opportunities do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect opportunities from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.Opportunity
  alias CopperApi.Queries
  import Ex2ms

  def list_opportunities_ets() do
    :ets.select(:copper_opportunities, match_all_without_view_state())
  end

  def list_opportunities() do
    Opportunity.read()
  end

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  def fetch_ets(opportunity_id) do
    [{_key, opportunity}] = :ets.lookup(:copper_opportunities, opportunity_id)
    opportunity
  end

  def fetch(opportunity_id) do
    Queries.Opportunities.by_copper_id(opportunity_id) |> List.first()
  end

  def list_opportunities_related_to_tasks() do
    CopperApi.Queries.Tasks.list_tasks_related_to_opportunities()
    |> Enum.map(fn %{related_resource: %{id: id}} ->
      try do
        fetch(id)
      rescue
        _ -> nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
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
    tid = :ets.new(:copper_opportunities, [:named_table, :set, :public, read_concurrency: true])
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_cache, state) do
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

  def ets_insert(%Opportunity{id: id} = lead) do
    :ets.insert(:copper_opportunities, {id, lead})
  end

  defp insert_or_update_postgres(item) do
    case Queries.Opportunities.by_copper_id(item.copper_id) |> List.first() do
      nil -> Opportunity.create(item |> Map.from_struct())
      existing -> existing
    end
    |> Opportunity.update(item |> Map.from_struct())
  end

  defp refresh_cache() do
    stream_opportunities_from_copper()
    |> Task.async_stream(&insert_or_update_postgres/1)
    |> Stream.run()

    Messaging.publish("CopperApi", :copper_opportunities_updated)
    set_live_status()
    IO.puts("\n \n ======= Copper Opportunities Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.hours(24))
  end

  defp current_year() do
    {integer, _} = TimeApi.today() |> Timex.format!("{YYYY}") |> Integer.parse()
    integer
  end

  defp stream_opportunities_from_copper() do
    CopperApi.stream_opportunities(
      TimeApi.start_of_year(2016),
      TimeApi.end_of_year(current_year())
    )
  end
end
