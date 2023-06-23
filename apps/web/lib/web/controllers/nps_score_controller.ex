defmodule Web.NpsScoreController do
  use Web, :controller

  def send_to_netsuite(conn, params) do
    with {:ok, _job} <- SkylineOperations.send_nps_score_to_netsuite(params) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while sending nps score to netsuite from hubspot")
        respond_error(conn)
    end
  end

  def inspect(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
    respond_ok(conn)
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end

  defp respond_error(conn) do
    json(conn, %{status: :error})
  end
end
