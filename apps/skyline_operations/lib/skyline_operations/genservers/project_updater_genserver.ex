defmodule SkylineOperations.HubspotDealToNetsuiteProjectRefresher do
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
    HubspotApi.subscribe()
    {:ok, %{last_refresh: nil}}
  end

  def handle_info(:hubspot_deals_updated, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  # Private Helpers

  def refresh_cache() do
    SkylineOperations.update_netsuite_projects_with_finance_fees_and_cash_price()

    IO.puts("\n \n ======= Refreshed Netsuite Projects with Hubspot Info ======= \n \n")
    :ok
  end
end
