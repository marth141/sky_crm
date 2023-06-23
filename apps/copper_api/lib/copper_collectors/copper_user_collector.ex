defmodule CopperApi.Users do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect users from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.User
  import Ex2ms

  def list_users() do
    :ets.select(:copper_users, match_all_without_view_state())
  end

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  def fetch(id) do
    [{_key, user}] = :ets.lookup(:copper_users, id)
    user
  end

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      # module genserver will call
      __MODULE__,
      # init params
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    tid = :ets.new(:copper_users, [:named_table, :set, :public, read_concurrency: true])
    :ets.insert(:copper_users, {:view_state, default_view_state()})
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  # Private Helpers

  defp insert_to_ets(%User{id: id} = user) do
    :ets.insert(:copper_users, {id, user})
  end

  defp default_view_state,
    do: %{
      example: 0
    }

  defp refresh_cache() do
    users = fetch_all_users_from_copper()
    Enum.each(users, &insert_to_ets/1)
    Messaging.publish("CopperApi", :copper_users_updated)
    IO.puts("\n \n ======= Copper Users Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.hours(24))
  end

  def current_date() do
    Timex.now("America/Denver")
    |> Timex.to_date()
  end

  defp fetch_all_users_from_copper() do
    CopperApi.list_users()
  end
end
