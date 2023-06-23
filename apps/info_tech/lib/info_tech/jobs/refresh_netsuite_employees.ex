defmodule InfoTech.RefreshNetsuiteEmployees do
  use Oban.Worker,
    queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      NetsuiteApi.EmployeeCollector.refresh_cache()
      {:ok, "Synced Netsuite Employees"}
    rescue
      e -> e
    end
  end
end
