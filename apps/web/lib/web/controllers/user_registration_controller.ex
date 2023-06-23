defmodule Web.UserRegistrationController do
  use Web, :controller

  alias Identity.User
  alias Web.UserAuth

  def new(conn, _params) do
    changeset = Identity.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with false <- Identity.any_active_admins?(),
         {:ok, user} <- Identity.register_user_admin(user_params) do
      {:ok, _} =
        Identity.deliver_user_confirmation_instructions(
          user,
          &Routes.user_confirmation_url(conn, :confirm, &1)
        )

      conn
      |> put_flash(:info, "User created successfully.")
      |> UserAuth.login_user(user)
    else
      true ->
        conn
        |> put_flash(
          :error,
          "User Registration Failed, you will need to contact an admin to get registered."
        )
        |> redirect(to: Routes.user_session_path(conn, :new))
    end

    # case Identity.register_user(user_params) do
    #   {:ok, user} ->
    #     {:ok, _} =
    #       Identity.deliver_user_confirmation_instructions(
    #         user,
    #         &Routes.user_confirmation_url(conn, :confirm, &1)
    #       )

    #     conn
    #     |> put_flash(:info, "User created successfully.")
    #     |> UserAuth.login_user(user)

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end
end
