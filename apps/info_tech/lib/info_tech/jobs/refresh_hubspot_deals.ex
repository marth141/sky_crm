defmodule InfoTech.RefreshHubspotDeals do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      HubspotApi.DealCollector.refresh_cache()
      {:ok, "Synced Hubspot Deals"}
    rescue
      e -> e
    end
  end
end
