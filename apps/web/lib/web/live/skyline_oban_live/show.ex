defmodule Web.SkylineObanLive.Show do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, socket |> assign_current_user(session)}
  end

  @impl true
  def handle_event("retry_job", _state, socket) do
    Oban.retry_job(socket.assigns.oban_job.id)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    {
      :noreply,
      socket
      |> assign(:oban_job, InfoTech.oban_get_job_by_id(socket.assigns.oban_job.id))
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:oban_job, InfoTech.oban_get_job_by_id(id))}
  end

  defp page_title(:show), do: "Show Oban Job"
end
