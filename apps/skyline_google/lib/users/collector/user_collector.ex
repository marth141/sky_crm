defmodule SkylineGoogle.Users.Collector do
  use GenServer
  import Ex2ms

  def list_users() do
    :ets.select(:google_user_list, ets_match_all())
  end

  def fetch(user_id) do
    [{_key, user}] = :ets.lookup(:google_user_list, user_id)
    user
  end

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def init(_opts) do
    tid =
      :ets.new(:google_user_list, [
        :named_table,
        :set,
        :public,
        read_concurrency: true
      ])

    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_cache, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    case Application.get_env(:skyline_google, :env) do
      :dev ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :test ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :prod ->
        schedule_init()
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    end
  end

  defp ets_match_all() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  defp ets_insert(id, item) do
    :ets.insert(:google_user_list, {id, item})
  end

  defp refresh_cache() do
    get_users()
    |> Enum.each(&ets_insert(&1.id, &1))

    Messaging.publish(
      "SkylineGoogle",
      :google_users_updated
    )

    IO.puts("\n \n ======= Google Users Refreshed =======")
    schedule_poll()
    :ok
  end

  def get_users() do
    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/admin.directory.user",
        "it_bot@org"
      )

    g_conn = GoogleApi.Admin.Directory_v1.Connection.new(token.token)

    {:ok, %{users: users}} =
      GoogleApi.Admin.Directory_v1.Api.Users.directory_users_list(g_conn,
        domain: "org",
        maxResults: 200
      )

    users
  end

  defp schedule_init do
    Process.send_after(self(), :refresh_cache, :timer.minutes(10))
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.hours(24))
  end
end
