defmodule ATest do
  import Ecto.Query

  def get_contacts_group_by_year_month_day_hour() do
    Repo.all(from(c in HubspotApi.Contact, select: c.createdAt))
    |> Enum.map(fn string ->
      {:ok, dt, _} = DateTime.from_iso8601(string)
      DateTime.shift_zone!(dt, "America/Denver")
    end)
    |> Enum.group_by(& &1.year)
    |> Enum.map(fn {year, data} ->
      {year,
       Enum.group_by(data, fn datetime ->
         datetime.month
       end)
       |> Enum.map(fn {month, data} ->
         {month,
          Enum.group_by(data, fn datetime -> datetime.day end)
          |> Enum.map(fn {day, data} ->
            {day,
             Enum.group_by(data, fn datetime -> datetime.hour end)
             |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
             |> Map.new()}
          end)
          |> Map.new()}
       end)
       |> Map.new()}
    end)
    |> Map.new()
  end

  def test() do
    Repo.all(from(c in HubspotApi.Contact, select: c.createdAt))
    |> Enum.map(fn createdAt ->
      {:ok, dt, _} = DateTime.from_iso8601(createdAt)
      DateTime.shift_zone!(dt, "America/Denver")
    end)
    |> Enum.group_by(fn datetime ->
      datetime.year
    end)
    |> Enum.map(fn {year, list_of_datetime} ->
      hours_and_time =
        Enum.group_by(list_of_datetime, fn datetime -> datetime.hour end)
        |> Enum.map(fn {hour, list_of_datetime} ->
          {hour, Enum.count(list_of_datetime)}
        end)
        |> Map.new()

      {year, hours_and_time}
    end)
    |> Map.new()
    # |> Enum.map(fn {year, data} ->
    #   file = File.open!("#{year} Contacts Created by Time.csv", [:write, :utf8])

    #   [data]
    #   |> CSV.encode(headers: true)
    #   |> Enum.each(&IO.write(file, &1))

    #   File.close(file)
    # end)
  end

  def test_all_time() do
    Repo.all(from(c in HubspotApi.Contact, select: c.createdAt))
    |> Enum.map(fn string ->
      {:ok, dt, _} = DateTime.from_iso8601(string)
      DateTime.shift_zone!(dt, "America/Denver")
    end)
    |> Enum.group_by(fn datetime -> datetime.hour end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Map.new()
  end
end
