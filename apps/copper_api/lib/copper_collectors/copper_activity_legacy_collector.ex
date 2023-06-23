defmodule CopperApi.LegacyActivity do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect activities from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.Activity

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def init(_opts) do
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_continue(:init, state) do
    refresh_legacy()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  defp refresh_legacy() do
    years = legacy_years()

    Task.async_stream(
      years,
      fn year ->
        year_list =
          stream_activities_from_copper(year)
          |> Enum.chunk_every(100)

        {
          Enum.each(year_list, fn chunk ->
            Repo.insert_all(Activity, chunk,
              on_conflict: :replace_all,
              conflict_target: :copper_id
            )
          end),
          year,
          "Activities"
        }
        |> IO.inspect()
      end,
      timeout: 3_600_000
    )
    |> Stream.run()

    Messaging.publish("CopperApi", :copper_activity_legacy_updated)

    IO.puts("\n \n ======= Copper Legacy Activities Refreshed ======= \n \n")
    schedule_poll_legacy()
    :ok
  end

  defp schedule_poll_legacy do
    Process.send_after(self(), :refresh_legacy, :timer.hours(24))
  end

  defp legacy_years() do
    2016..2020
  end

  defp stream_activities_from_copper(year) do
    CopperApi.stream_activities(
      TimeApi.start_of_year(year),
      TimeApi.end_of_year(year),
      "some_copper_id"
    )
  end
end
