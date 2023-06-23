defmodule Web.PageLive do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok,
     assign_current_user(socket, session)
     |> assign(:finished?, "Not Executed")
     |> assign(:time, get_time())
     |> assign(:oban_completed_job_counts, InfoTech.count_of_completed_oban_groups(:list))
     |> assign(:oban_retryable_job_counts, InfoTech.count_of_retryable_oban_groups(:list))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "SkyCRM Integration Dashboard")
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply,
     socket
     |> assign(:time, get_time())
     |> assign(:oban_completed_job_counts, InfoTech.count_of_completed_oban_groups(:list))
     |> assign(:oban_retryable_job_counts, InfoTech.count_of_retryable_oban_groups(:list))}
  end

  defp get_time() do
    DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)
  end
end
