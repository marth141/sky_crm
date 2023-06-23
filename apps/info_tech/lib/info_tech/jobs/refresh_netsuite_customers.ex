defmodule InfoTech.RefreshNetsuiteCustomers do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      NetsuiteApi.CustomerCollector.refresh_cache()
      {:ok, "Synced Netsuite Customers"}
    rescue
      e -> e
    end
  end
end
