defmodule Web.OperationsMonthlyInstallForecastLive.Index do
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
     |> assign(:datas, test_data())
     |> assign_current_user(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:tick, socket) do
    time = DateTime.utc_now() |> TimeApi.to_mst() |> DateTime.truncate(:second)

    {:noreply,
     socket
     |> assign(:time, time)
     |> assign(:datas, test_data())}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Operations Monthly Installs")
  end

  defp test_data() do
    [
      %{
        start_date: ~D[2021-08-30],
        end_date: ~D[2021-09-03],
        norco: 2,
        wesco: 2,
        soco: 1,
        utah: 0,
        cria: 3,
        total_scheduled: 8,
        goal: 8,
        actual: 0,
        percent_variance_from_goal: 0,
        variance_from_goal: -8,
        rev_goal: 276_000,
        actual_rev: 0,
        approx_difference_from_forecast: 276_000,
        percent_to_goal: 0
      }
    ]
  end

  def query_copper_for_opportunities_within_five_weeks(month) do
    TimeApi.get_five_weeks_as_unix(month)
    |> Enum.map(fn {beginning, ending} ->
      list =
        CopperApi.Queries.execute_query(
          SkylineOperations.Queries.get_installs_by_dates(beginning, ending)
        )

      build_result_obj(list, month, beginning, ending)
    end)
  end

  def query_copper_for_opportunities_within_five_weeks() do
    TimeApi.get_five_weeks_as_unix()
    |> Enum.map(fn {beginning, ending} ->
      list =
        CopperApi.Queries.execute_query(
          SkylineOperations.Queries.get_installs_by_dates(beginning, ending)
        )

      build_result_obj(list, beginning, ending)
    end)
  end

  def build_result_obj(list, month, beginning, ending) do
    %{
      week: "Week #{build_week_number(month, beginning, ending)}",
      beginning: beginning |> TimeApi.from_unix(),
      ending: ending |> TimeApi.from_unix(),
      list: list,
      count: list |> Enum.count(),
      list_by_area: list |> Enum.group_by(fn o -> o.install_area end),
      count_by_area:
        list
        |> Enum.group_by(fn o -> o.install_area end)
        |> Enum.map(fn {k, v} -> {k, v |> Enum.count()} end)
    }
  end

  def build_result_obj(list, beginning, ending) do
    %{
      week: "Week #{build_week_number(beginning, ending)}",
      beginning: beginning |> TimeApi.from_unix(),
      ending: ending |> TimeApi.from_unix(),
      list: list,
      count: list |> Enum.count(),
      list_by_area: list |> list_by_area(),
      count_by_area:
        list
        |> count_by_area()
    }
  end

  def list_by_area(list) do
    list
    |> Enum.group_by(fn o -> o.install_area end)
  end

  def count_by_area(list) do
    list
    |> Enum.group_by(fn o -> o.install_area end)
    |> Enum.map(fn {k, v} -> {k, v |> Enum.count()} end)
  end

  def build_week_number(month, beginning, ending) do
    (TimeApi.get_five_weeks_as_unix(month)
     |> Enum.find_index(fn element -> element == {beginning, ending} end)) + 1
  end

  def build_week_number(beginning, ending) do
    (TimeApi.get_five_weeks_as_unix()
     |> Enum.find_index(fn element -> element == {beginning, ending} end)) + 1
  end
end
