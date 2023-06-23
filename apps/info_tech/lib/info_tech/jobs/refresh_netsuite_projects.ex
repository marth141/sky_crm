defmodule InfoTech.RefreshNetsuiteProjects do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      NetsuiteApi.ProjectCollector.refresh_cache()
      {:ok, "Synced Netsuite Projects"}
    rescue
      e -> e
    end
  end
end
