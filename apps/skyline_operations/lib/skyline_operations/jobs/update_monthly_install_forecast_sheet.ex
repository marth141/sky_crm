defmodule SkylineOperations.Jobs.UpdateMonthlyInstallForecastSheet do
  use Oban.Worker, queue: :skyline_operations

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    :ok
  end

  def query_copper_for_opportunities_within_five_weeks(n) do
    TimeApi.get_five_weeks_as_unix(n)
    |> Enum.map(fn {beginning, ending} ->
      import Ecto.Query

      list =
        CopperApi.Queries.execute_query(
          from(o in CopperApi.Schemas.Opportunity,
            where:
              (o.install_date >= ^beginning and o.install_date <= ^ending) or
                (o.install_completed_date >= ^beginning and o.install_completed_date <= ^ending) or
                (o.install_funded_date >= ^beginning and o.install_funded_date <= ^ending),
            select: o
          )
        )

      %{
        week: "Week #{build_week_number(n, beginning, ending)}",
        beginning: beginning |> TimeApi.from_unix(),
        ending: ending |> TimeApi.from_unix(),
        list: list,
        count: list |> Enum.count(),
        list_by_area: list |> Enum.group_by(fn o -> o.install_area end)
      }
    end)
  end

  def query_copper_for_opportunities_within_five_weeks() do
    TimeApi.get_five_weeks_as_unix()
    |> Enum.map(fn {beginning, ending} ->
      list =
        CopperApi.Queries.execute_query(
          SkylineOperations.Queries.get_installs_by_dates(beginning, ending)
        )

      %{
        week: "Week #{build_week_number(beginning, ending)}",
        beginning: beginning |> TimeApi.from_unix(),
        ending: ending |> TimeApi.from_unix(),
        list: list,
        count: list |> Enum.count(),
        list_by_area: list |> Enum.group_by(fn o -> o.install_area end)
      }
    end)
  end

  def test_some_complex_thing_count(month) do
    list =
      SkylineOperations.Jobs.UpdateMonthlyInstallForecastSheet.query_copper_for_opportunities_within_five_weeks(
        month
      )

    list
    |> Enum.map(fn w -> w.list |> Enum.map(fn r -> r.name end) end)
  end

  def test_some_complex_thing(week, area) do
    list =
      SkylineOperations.Jobs.UpdateMonthlyInstallForecastSheet.query_copper_for_opportunities_within_five_weeks()

    list
    |> Enum.group_by(fn r -> r.week end)
    |> Map.get(week)
    |> List.first()
    |> Map.get(:list_by_area)
    |> Map.get(area)
  end

  def test_some_complex_thing() do
    list =
      SkylineOperations.Jobs.UpdateMonthlyInstallForecastSheet.query_copper_for_opportunities_within_five_weeks()

    list
    |> Enum.group_by(fn r -> r.week end)
    |> Map.get("Week 5")
    |> List.first()
    |> Map.get(:list_by_area)
    |> Map.get("Norco")
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
