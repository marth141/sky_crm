defmodule Web.EquipmentLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_current_user(session)}
  end
end
