defmodule SkylineOperations.RefreshNetsuiteStatusGenserver do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      SkylineOperations.NetsuiteStatusGenserver2ElectricBoogaloo.refresh_cache()
      {:ok, "Synced Statuses"}
    rescue
      e -> e
    end
  end
end
