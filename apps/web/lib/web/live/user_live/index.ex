defmodule Web.UserLive.Index do
  use Web, :live_view

  alias Identity.User

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:users, fetch_users())
     |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Identity.get_user!(id))
  end

  defp apply_action(socket, :add_user, _params) do
    socket
    |> assign(:page_title, "Add a new User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("deactivate", %{"id" => id}, socket) do
    user = Identity.get_user!(id)
    {:ok, _} = Identity.deactivate_user(user.id)

    {:noreply, assign(socket, :users, fetch_users())}
  end

  @impl true
  def handle_event("activate", %{"id" => id}, socket) do
    user = Identity.get_user!(id)
    {:ok, _} = Identity.activate_user(user.id)

    {:noreply, assign(socket, :users, fetch_users())}
  end

  defp fetch_users do
    Identity.list_users()
  end
end
