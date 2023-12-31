defmodule Web.UserOauthController do
  use Web, :controller
  alias Identity
  alias Web.UserAuth
  plug Ueberauth
  @rand_pass_length 32
  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, %{"provider" => "google"}) do
    user_params = %{email: user_info.email, password: random_password()}

    case Identity.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.login_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
