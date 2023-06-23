defmodule SkylineOperations.SendNMADocument do
  use Oban.Worker,
    queue: :skyline_operations

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    try do
      SkylineOperations.NMADocumentSender.refresh_cache()
      {:ok, "Sent NMA Documents"}
    catch
      e -> e
    end
  end
end
