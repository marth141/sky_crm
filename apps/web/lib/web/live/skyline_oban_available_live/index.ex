defmodule Web.SkylineObanAvailableLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:ok,
     socket
     |> assign(oban_jobs: list_oban_jobs())
     |> assign(:time, time)
     |> assign_current_user(session)}
  end

  def handle_params(%{"page" => page, "per_page" => per_page}, _url, socket) do
    page = maybe_convert(page, :integer) |> validate_page(socket.assigns.oban_jobs.page_count)

    per_page = maybe_convert(per_page, :integer)

    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:noreply,
     socket
     |> assign(:oban_jobs, list_oban_jobs(page: page, per_page: per_page))
     |> assign(:time, time)}
  end

  def handle_params(%{"per_page" => per_page}, _url, socket) do
    per_page =
      maybe_convert(per_page, :integer)
      |> validate_page(socket.assigns.oban_jobs.page_count)

    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:noreply,
     socket |> assign(:oban_jobs, list_oban_jobs(per_page: per_page)) |> assign(:time, time)}
  end

  def handle_params(%{"page" => page}, _url, socket) do
    page = maybe_convert(page, :integer) |> validate_page(socket.assigns.oban_jobs.page_count)
    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:noreply, socket |> assign(:oban_jobs, list_oban_jobs(page: page)) |> assign(:time, time)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Oban Jobs")
  end

  defp maybe_convert(param, :integer) when is_binary(param) do
    String.to_integer(param)
  end

  defp maybe_convert(param, :integer) when is_integer(param), do: param

  defp validate_page(param, _last_page) when param <= 0, do: 1

  defp validate_page(param, last_page) when param >= last_page, do: last_page

  defp validate_page(param, _last_page), do: param

  defp list_oban_jobs(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 10)
    InfoTech.oban_see_jobs_paginated_by_state(:available, page: page, per_page: per_page)
  end
end
