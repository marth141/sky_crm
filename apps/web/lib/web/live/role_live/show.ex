defmodule Web.RoleLive.Show do
  use Web, :live_view

  alias Identity.UserRoles

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign_current_user(session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:role, UserRoles.get_role!(id))}
  end

  defp page_title(:show), do: "Show Role"
  defp page_title(:edit), do: "Edit Role"
end
