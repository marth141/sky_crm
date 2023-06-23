defmodule Web.Headers do
  @behaviour Plug
  import Plug.Conn

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _params) do
    conn
    |> put_resp_header("cache-control", "public max-age=31436000")
  end
end
