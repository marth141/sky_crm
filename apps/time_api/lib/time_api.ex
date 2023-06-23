defmodule TimeApi do
  @moduledoc """
  Documentation for `TimeApi`.

  This module is to be able to provide time functions for most of the things in the SkyCRM umbrella.

  Many of these functions are just a wrapper over Timex and in some places Timex might be used.

  Most of these functions will set any DateTime structs into Mountain Standard Time
  because that is where Org's headquarters are.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TimeApi.hello()
      :world

  """
  def hello do
    :world
  end

  def get_five_weeks_as_unix(n) do
    get_five_weeks_from_end_of_month(n)
    |> Enum.map(fn {beginning, ending} ->
      {beginning |> Timex.to_unix(), ending |> Timex.to_unix()}
    end)
  end

  def get_five_weeks_as_unix() do
    get_five_weeks_from_end_of_month()
    |> Enum.map(fn {beginning, ending} ->
      {beginning |> Timex.to_unix(), ending |> Timex.to_unix()}
    end)
  end

  def get_five_weeks_from_end_of_month(n) do
    [
      {end_of_month(n) |> Timex.beginning_of_week(:sun),
       end_of_month(n) |> Timex.end_of_week(:sun)},
      {end_of_month(n) |> n_days_ago(7 * 1) |> Timex.beginning_of_week(:sun),
       end_of_month(n)
       |> n_days_ago(7 * 1)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month(n) |> n_days_ago(7 * 2) |> Timex.beginning_of_week(:sun),
       end_of_month(n)
       |> n_days_ago(7 * 2)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month(n) |> n_days_ago(7 * 3) |> Timex.beginning_of_week(:sun),
       end_of_month(n)
       |> n_days_ago(7 * 3)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month(n) |> n_days_ago(7 * 4) |> Timex.beginning_of_week(:sun),
       end_of_month(n)
       |> n_days_ago(7 * 4)
       |> Timex.end_of_week(:sun)
       |> end_of_day()}
    ]
  end

  def get_five_weeks_from_end_of_month() do
    [
      {end_of_month() |> Timex.beginning_of_week(:sun),
       end_of_month() |> Timex.end_of_week(:sun)},
      {end_of_month() |> n_days_ago(7 * 1) |> Timex.beginning_of_week(:sun),
       end_of_month()
       |> n_days_ago(7 * 1)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month() |> n_days_ago(7 * 2) |> Timex.beginning_of_week(:sun),
       end_of_month()
       |> n_days_ago(7 * 2)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month() |> n_days_ago(7 * 3) |> Timex.beginning_of_week(:sun),
       end_of_month()
       |> n_days_ago(7 * 3)
       |> Timex.end_of_week(:sun)
       |> end_of_day()},
      {end_of_month() |> n_days_ago(7 * 4) |> Timex.beginning_of_week(:sun),
       end_of_month()
       |> n_days_ago(7 * 4)
       |> Timex.end_of_week(:sun)
       |> end_of_day()}
    ]
  end

  def get_day(year, month, day) do
    {:ok, date} = Date.new(year, month, day)

    date
    |> to_mst()
    |> Timex.beginning_of_day()
  end

  def get_day(:start, year, month, day) do
    {:ok, date} = Date.new(year, month, day)

    date
    |> to_mst()
    |> Timex.beginning_of_day()
  end

  def get_day(:end, year, month, day) do
    {:ok, date} = Date.new(year, month, day)

    date
    |> to_mst()
    |> Timex.end_of_day()
  end

  def today() do
    mst_now()
    |> Timex.end_of_day()
  end

  def end_of_day() do
    TimeApi.mst_now()
    |> Timex.end_of_day()
  end

  def end_of_day(datetime) do
    Timex.end_of_day(datetime)
  end

  def beginning_of_day() do
    TimeApi.mst_now()
    |> Timex.beginning_of_day()
  end

  def beginning_of_day(datetime) do
    Timex.beginning_of_day(datetime)
  end

  def yesterday() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(1))
    |> Timex.beginning_of_day()
  end

  def start_of_week() do
    mst_now()
    |> Timex.beginning_of_week()
    |> Timex.beginning_of_day()
  end

  def end_of_week() do
    mst_now()
    |> Timex.end_of_week()
    |> Timex.end_of_day()
  end

  def start_of_last_week() do
    mst_now()
    |> Timex.beginning_of_week()
    |> Timex.subtract(Timex.Duration.from_days(7))
    |> Timex.beginning_of_day()
  end

  def start_of_last_two_weeks() do
    mst_now()
    |> Timex.beginning_of_week()
    |> Timex.subtract(Timex.Duration.from_days(14))
    |> Timex.beginning_of_day()
  end

  def start_of_month() do
    mst_now()
    |> Timex.beginning_of_month()
    |> Timex.beginning_of_day()
  end

  def end_of_month() do
    mst_now()
    |> Timex.end_of_month()
    |> Timex.end_of_day()
  end

  def end_of_month(n) do
    mst_now()
    |> Timex.set(month: n)
    |> Timex.end_of_month()
    |> Timex.end_of_day()
  end

  def start_of_last_month() do
    mst_now()
    |> Timex.beginning_of_month()
    |> Timex.subtract(Timex.Duration.from_days(1))
    |> Timex.beginning_of_month()
    |> Timex.beginning_of_day()
  end

  def end_of_last_month() do
    mst_now()
    |> Timex.beginning_of_month()
    |> Timex.subtract(Timex.Duration.from_days(1))
    |> Timex.end_of_month()
    |> Timex.end_of_day()
  end

  def n_days_ago(datetime, n) do
    datetime
    |> Timex.subtract(Timex.Duration.from_days(n))
    |> Timex.beginning_of_day()
  end

  def seven_days_ago() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(7))
    |> Timex.beginning_of_day()
  end

  def fourteen_days_ago() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(14))
    |> Timex.beginning_of_day()
  end

  def thirty_days_ago() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(30))
    |> Timex.beginning_of_day()
  end

  def sixty_days_ago() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(60))
    |> Timex.beginning_of_day()
  end

  def ninety_days_ago() do
    mst_now()
    |> Timex.subtract(Timex.Duration.from_days(90))
    |> Timex.beginning_of_day()
  end

  def start_of_year() do
    mst_now()
    |> Timex.beginning_of_year()
    |> Timex.beginning_of_day()
  end

  def start_of_year(year) do
    mst_now()
    |> Timex.set(year: year)
    |> Timex.beginning_of_year()
    |> Timex.beginning_of_day()
  end

  def end_of_first_quarter() do
    mst_now()
    |> Timex.set(month: 3, day: 31)
    |> Timex.end_of_day()
  end

  def end_of_first_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 3, day: 31)
    |> Timex.end_of_day()
  end

  def start_of_second_quarter() do
    mst_now()
    |> Timex.set(month: 4, day: 1)
    |> Timex.beginning_of_day()
  end

  def start_of_second_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 4, day: 1)
    |> Timex.beginning_of_day()
  end

  def end_of_second_quarter() do
    mst_now()
    |> Timex.set(month: 6, day: 30)
    |> Timex.end_of_day()
  end

  def end_of_second_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 6, day: 30)
    |> Timex.end_of_day()
  end

  def start_of_third_quarter() do
    mst_now()
    |> Timex.set(month: 7, day: 1)
    |> Timex.beginning_of_day()
  end

  def start_of_third_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 7, day: 1)
    |> Timex.beginning_of_day()
  end

  def end_of_third_quarter() do
    mst_now()
    |> Timex.set(month: 9, day: 30)
    |> Timex.end_of_day()
  end

  def end_of_third_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 9, day: 30)
    |> Timex.end_of_day()
  end

  def start_of_fourth_quarter() do
    mst_now()
    |> Timex.set(month: 10, day: 1)
    |> Timex.beginning_of_day()
  end

  def start_of_fourth_quarter(year) do
    mst_now()
    |> Timex.set(year: year, month: 10, day: 1)
    |> Timex.beginning_of_day()
  end

  def end_of_year() do
    mst_now()
    |> Timex.end_of_year()
    |> Timex.end_of_day()
  end

  def end_of_year(year) do
    mst_now()
    |> Timex.set(year: year)
    |> Timex.end_of_year()
    |> Timex.end_of_day()
  end

  def mst_now() do
    Timex.now()
    |> to_mst()
  end

  def to_mst(%DateTime{} = input) do
    input
    |> Timex.to_datetime("America/Denver")
  end

  def to_mst(%Date{} = input) do
    input
    |> Timex.to_datetime("America/Denver")
  end

  def to_mst(%NaiveDateTime{} = input) do
    input
    |> Timex.to_datetime("America/Denver")
  end

  def to_utc(%DateTime{} = input) do
    input
    |> Timex.to_datetime("Etc/UTC")
  end

  def to_utc(%Date{} = input) do
    input
    |> Timex.to_datetime("Etc/UTC")
  end

  def datetime_period_to_unix(%DateTime{} = start_time, %DateTime{} = end_time) do
    {DateTime.to_unix(start_time), DateTime.to_unix(end_time)}
  end

  def to_unix(%DateTime{} = time, :millisecond) do
    DateTime.to_unix(time, :millisecond)
  end

  def to_unix(%Date{} = time) do
    {:ok, datetime} = DateTime.new(time, ~T[00:00:00.000], "America/Denver")

    datetime
    |> to_unix()
  end

  def to_unix(%DateTime{} = time) do
    DateTime.to_unix(time)
  end

  def from_unix(unix_time, atom) do
    DateTime.from_unix!(unix_time, atom)
    |> to_mst()
  end

  def from_unix(unix_time) do
    DateTime.from_unix!(unix_time)
    |> to_mst()
  end

  def parse_to_date(date_string) do
    case DateTimeParser.parse_date(date_string) do
      {:ok, date} ->
        date

      {:error, "Could not parse nil"} ->
        date_string
    end
  end

  def parse_to_datetime(date_string) do
    case DateTimeParser.parse_datetime(date_string, assume_time: true) do
      {:ok, datetime} ->
        datetime

      {:error, "Could not parse nil"} ->
        date_string
    end
  end
end
