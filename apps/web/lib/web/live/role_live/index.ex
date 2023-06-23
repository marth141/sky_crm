defmodule Web.RoleLive.Index do
  use Web, :live_view

  alias Identity.UserRoles
  alias Identity.UserRoles.Role

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :user_roles, list_user_roles()) |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Role")
    |> assign(:role, UserRoles.get_role!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Role")
    |> assign(:role, %Role{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User roles")
    |> assign(:role, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    role = UserRoles.get_role!(id)
    {:ok, _} = UserRoles.delete_role(role)

    {:noreply, assign(socket, :user_roles, list_user_roles())}
  end

  defp list_user_roles do
    UserRoles.list_user_roles()
  end
end
