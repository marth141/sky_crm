defmodule CopperApi.Activity do
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
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  defp refresh_cache() do
    stream_activities_from_copper()
    |> Stream.map(&insert_or_update_postgres/1)
    |> Stream.run()

    Messaging.publish("CopperApi", :copper_activities_updated)
    IO.puts("\n \n ======= Copper Activities Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp insert_or_update_postgres(list_of_activities) do
    Repo.insert_all(Activity, list_of_activities,
      on_conflict: :replace_all,
      conflict_target: :copper_id
    )
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.minutes(10))
  end

  defp get_activity_ids do
    [
      # Finished - To Do
      339_094,
      # Taking a long time - Phone Call
      312_777,
      # Finished - Solar Consultation
      312_792,
      # None 2021 - Voice-to-Voice Phone Call
      450_336,
      # Taking a long time - Outreach
      716_430,
      915_804,
      # Taking a long time - Note
      0
    ]
  end

  def stream_activities_from_copper() do
    Task.async_stream(
      get_activity_ids(),
      fn copper_id ->
        CopperApi.stream_activities(
          TimeApi.start_of_year(2021),
          TimeApi.end_of_year(2021),
          copper_id
        )
      end,
      timeout: 300_000
    )
    |> Stream.map(fn {:ok, stream} -> stream |> Enum.to_list() end)
  end
end
