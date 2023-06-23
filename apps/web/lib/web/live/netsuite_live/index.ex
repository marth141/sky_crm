defmodule Web.NetsuiteApiLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok,
     socket
     |> assign(:time, get_time())
     |> assign(:result, nil)
     |> assign(:netsuite_hubspot_associations, get_associations())
     |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply,
     socket
     |> assign(:time, get_time())
     |> assign(:netsuite_hubspot_associations, get_associations())}
  end

  @impl true
  def handle_event("input_hubspot_deal", %{"hubspot_deal" => hubspot_deal}, socket) do
    socket = assign(socket, hubspot_deal: hubspot_deal)
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Netsuite Matters")
    |> assign(:role, nil)
  end

  defp get_time() do
    DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)
  end

  defp get_associations() do
    SkylineOperations.get_netsuite_hubspot_associations()
  end
end
