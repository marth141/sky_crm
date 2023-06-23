defmodule Web.Authorization do
  @moduledoc """
  Function plugs for authorization checks.
  """
  import Plug.Conn
  import Phoenix.Controller

  def require_admin(conn, _params) do
    if Identity.is_user_admin?(conn.assigns.current_user.id) do
      conn
    else
      conn
      |> put_flash(
        :error,
        "Please contact your administrator to manage users."
      )
      |> redirect(to: "/")
      |> halt()
    end
  end
end
