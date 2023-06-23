defmodule Web.SkylineObanLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok,
     socket
     |> assign(oban_jobs: list_oban_jobs())
     |> assign(:time, get_time())
     |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> assign(oban_jobs: list_oban_jobs()) |> assign(:time, get_time())}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Oban Jobs")
    |> assign(:role, nil)
  end

  defp list_oban_jobs(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 10)
    InfoTech.oban_see_jobs_paginated(page: page, per_page: per_page)
  end

  defp get_time() do
    DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)
  end
end
