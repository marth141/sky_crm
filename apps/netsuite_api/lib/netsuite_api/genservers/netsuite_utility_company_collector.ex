defmodule NetsuiteApi.UtilityCompanyCollector do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This is a GenSever that collects utility companies from Netsuite

  """
  use GenServer

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
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_cache, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    case Application.get_env(:netsuite_api, :env) do
      :dev ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :test ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :prod ->
        schedule_init_poll()
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    end
  end

  # Private Helpers

  def refresh_cache() do
    Repo.delete_all(NetsuiteApi.UtilityCompany)

    stream_utilities_from_netsuite()
    |> Task.async_stream(&relabel_id/1)
    |> Task.async_stream(&insert_or_update_postgres/1, timeout: :infinity)
    |> Stream.run()

    IO.puts("\n \n ======= Netsuite Utilities Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  # Todo it might be that if a project stage is completed, that the record is complete
  defp insert_or_update_postgres({:ok, netsuite_utility_company}) do
    try do
      existing =
        Repo.get_by!(NetsuiteApi.UtilityCompany,
          netsuite_case_id: netsuite_utility_company["netsuite_utility_company_id"]
        )

      existing
      |> NetsuiteApi.UtilityCompany.update(netsuite_utility_company)
    rescue
      _ -> NetsuiteApi.UtilityCompany.create(netsuite_utility_company)
    end
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.hours(4))
  end

  defp schedule_init_poll do
    Process.send_after(self(), :refresh_cache, :timer.minutes(1))
  end

  defp relabel_id(owner) do
    owner
    |> Enum.map(fn {k, v} ->
      if(k == "id", do: {"netsuite_utility_company_id", v}, else: {k, v})
    end)
    |> Map.new()
  end

  defp stream_utilities_from_netsuite() do
    NetsuiteApi.stream_netsuite_utility_companies()
  end
end
