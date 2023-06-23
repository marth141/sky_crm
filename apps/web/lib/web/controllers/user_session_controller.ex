defmodule Web.UserSessionController do
  use Web, :controller

  alias Identity
  alias Web.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    with %{is_active: true} = user <- Identity.get_user_by_email_and_password(email, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      %{is_active: false} = user ->
        conn
        |> put_flash(
          :error,
          "#{user.email} has been deactivated. Contact your administrator if you need assistance."
        )
        |> halt()

      nil ->
        render(conn, "new.html", error_message: "Invalid e-mail or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.logout_user()
  end
end
