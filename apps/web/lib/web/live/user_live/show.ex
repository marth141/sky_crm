defmodule Web.UserLive.Show do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign_current_user(session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Identity.get_user!(id))}
  end

  @impl true
  def handle_event("deactivate", _params, socket) do
    user = socket.assigns.user
    {:ok, _} = Identity.deactivate_user(user.id)

    {:noreply,
     socket
     |> assign(:user, Identity.get_user!(user.id))
     |> put_flash(:info, "#{user.email} Deactivated")}
  end

  @impl true
  def handle_event("activate", _params, socket) do
    user = socket.assigns.user
    {:ok, _} = Identity.activate_user(user.id)

    {:noreply,
     socket
     |> assign(:user, Identity.get_user!(user.id))
     |> put_flash(:info, "#{user.email} Reactivated")}
  end

  def handle_event("reset-password", _params, socket) do
    user = socket.assigns.user

    Identity.deliver_user_reset_password_instructions(
      user,
      &Routes.user_reset_password_url(socket, :edit, &1)
    )

    {:noreply, socket |> put_flash(:info, "Password reset instructions sent to #{user.email}")}
  end

  def handle_event("make-admin", _params, socket) do
    user = socket.assigns.user

    :ok = Identity.make_admin(user.id)

    {:noreply, socket |> put_flash(:info, "#{user.email} is now an administrator.")}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
