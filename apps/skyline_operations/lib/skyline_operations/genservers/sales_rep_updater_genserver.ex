defmodule SkylineOperations.SalesRepUpdater do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect records from Netsuite to figure out if status
  updates are needed between systems.

  """
  use GenServer

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
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_cache, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    case Application.get_env(:skyline_operations, :env) do
      :dev ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :test ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :prod ->
        schedule_init_poll()
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    end
  end

  # Private Helpers

  def refresh_cache() do
    SkylineOperations.update_all_projects_with_deal_sales_rep()

    IO.puts("\n \n ======= Sales Reps Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  def insert_or_update_postgres({:ok, deal}) do
    try do
      existing = Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: deal["hubspot_deal_id"])

      existing
      |> HubspotApi.Deal.update(deal)
    rescue
      _ -> HubspotApi.Deal.create(deal)
    end
  end

  defp schedule_poll do
    cond do
      TimeApi.mst_now().hour > 19 or TimeApi.mst_now().hour < 7 ->
        Process.send_after(self(), :refresh_cache, :timer.hours(4))

      true ->
        Process.send_after(self(), :refresh_cache, :timer.minutes(30))
    end
  end

  defp schedule_init_poll do
    Process.send_after(self(), :refresh_cache, :timer.minutes(1))
  end
end
