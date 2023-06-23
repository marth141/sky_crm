defmodule SkylineOperations.RefreshSalesRepGenserver do
  use Oban.Worker,
    queue: :long_updater

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      SkylineOperations.SalesRepUpdater.refresh_cache()
      {:ok, "Refreshed Sales Reps"}
    rescue
      e -> e
    end
  end
end
