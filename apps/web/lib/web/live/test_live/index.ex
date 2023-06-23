defmodule Web.TestLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:ok,
     socket
     |> assign(:time, time)
     |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:tick, socket) do
    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)
    {:noreply, socket |> assign(:time, time)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Oban Jobs")
    |> assign(:role, nil)
  end
end
