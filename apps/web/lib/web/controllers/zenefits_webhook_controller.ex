defmodule Web.ZenefitsWebhookController do
  @moduledoc """
  For doing stuff with messages from the Zenefits API Webhook
  """
  use Web, :controller

  @doc """
  Used to test looking at some incoming connection.
  Usually used to explore APIs.
  """
  @doc since: "Mar 25 2022"
  def inspect(conn, _params) do
    IO.inspect(conn, limit: :infinity)
    respond_ok(conn)
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end

  defp respond_error(conn) do
    json(conn, %{status: :error})
  end
end
