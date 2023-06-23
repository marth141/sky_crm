defmodule CopperApi.CustomerSource do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect customersources from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.CustomerSource
  import Ex2ms

  # Public API

  def list_customer_sources() do
    :ets.select(:copper_customer_sources, match_all_without_view_state())
  end

  def fetch_view_state() do
    [{_key, view_state}] = :ets.lookup(:copper_customer_sources, :view_state)
    view_state
  end

  def fetch(customer_source_id) do
    [{_key, customer_source}] = :ets.lookup(:copper_customer_sources, customer_source_id)
    customer_source
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
    tid =
      :ets.new(:copper_customer_sources, [:named_table, :set, :public, read_concurrency: true])

    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    try do
      refresh_cache()
      {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    rescue
      _e ->
        schedule_poll()
        {:noreply, state}
    end
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

  defp insert_to_ets(%CustomerSource{id: id} = customer_source) do
    :ets.insert(:copper_customer_sources, {id, customer_source})
  end

  defp refresh_cache() do
    to_insert = fetch_all_customer_sources_from_copper()
    Enum.each(to_insert, &insert_to_ets/1)

    Messaging.publish(
      "CopperApi",
      {:copper_customer_sources_updated, :copper_customer_sources}
    )

    IO.puts("\n \n ======= Copper Customer Sources Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.hours(24))
  end

  defp fetch_all_customer_sources_from_copper() do
    CopperApi.list_customer_sources()
  end
end
