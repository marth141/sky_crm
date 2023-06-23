defmodule NetsuiteApi.SalesAddersCollector do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This is a GenSever that collects States from Netsuite

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
    Repo.delete_all(NetsuiteApi.SalesAdder)

    stream_list_from_netsuite("customlist_skl_adders")
    |> Task.async_stream(&relabel_id/1)
    |> Task.async_stream(&insert_or_update_postgres/1, timeout: :infinity)
    |> Stream.run()

    IO.puts("\n \n ======= Netsuite Sales Adders Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp insert_or_update_postgres({:ok, netsuite_record}) do
    try do
      existing =
        Repo.get_by!(NetsuiteApi.SalesAdder,
          netsuite_sales_adder_id: netsuite_record["netsuite_sales_adder_id"]
        )

      existing
      |> NetsuiteApi.SalesAdder.update(netsuite_record)
    rescue
      _ -> NetsuiteApi.SalesAdder.create(netsuite_record)
    end
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.hours(4))
  end

  defp schedule_init_poll do
    Process.send_after(self(), :refresh_cache, :timer.minutes(1))
  end

  defp relabel_id(netsuite_record) do
    netsuite_record
    |> Enum.map(fn {k, v} -> if(k == "id", do: {"netsuite_sales_adder_id", v}, else: {k, v}) end)
    |> Map.new()
    |> Map.delete("links")
  end

  defp stream_list_from_netsuite(list) do
    NetsuiteApi.get_netsuite_list(list)
  end
end
