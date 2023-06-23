defmodule InfoTech.RefreshHubspotOwners do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      HubspotApi.OwnerCollector.refresh_cache()
      {:ok, "Synced Hubspot Owner"}
    rescue
      e -> e
    end
  end
end
