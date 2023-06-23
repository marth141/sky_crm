defmodule HubspotApi.DealCollector do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A GenServer that collects deals from Hubspot

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
    case Application.get_env(:hubspot_api, :env) do
      :dev ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :test ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :prod ->
        schedule_init_poll()
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    end
  end

  def handle_cast(:contacts_done, state) do
    refresh_cache()
    {:noreply, state}
  end

  # Private Helpers

  def refresh_cache() do
    Repo.delete_all(HubspotApi.Deal)

    stream_deals_from_hubspot()
    |> Task.async_stream(&insert_or_update_postgres/1, timeout: :infinity)
    |> Stream.run()

    HubspotApi.publish(:hubspot_deals_updated)
    IO.puts("\n \n ======= Hubspot Deals Refreshed ======= \n \n")
    # schedule_poll()
    GenServer.cast(HubspotApi.OwnerCollector, :deals_done)
    :ok
  end

  # Todo it might be that if a project stage is completed, that the record is complete
  def insert_or_update_postgres(%HubspotApi.Deal{hubspot_deal_id: deal_id} = deal) do
    try do
      existing = Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: deal_id)

      existing
      |> HubspotApi.Deal.update(deal)
    rescue
      _ -> HubspotApi.Deal.create(deal)
    end
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_cache, :timer.hours(4))
  end

  defp schedule_init_poll do
    Process.send_after(self(), :refresh_cache, :timer.minutes(1))
  end

  defp stream_deals_from_hubspot() do
    vacuum_hubspot_deals()
  end

  def vacuum_hubspot_deals() do
    start_fun = fn ->
      case HubspotApi.list_deals() do
        %HubspotApi.DealList{paging: paging, results: results} when is_map(paging) ->
          {results, paging.next.link}

        %HubspotApi.DealList{paging: paging, results: results} when is_nil(paging) ->
          {results, nil}

        {:ok, %{status: 429}} ->
          vacuum_hubspot_deals()
      end
    end

    next_fun = fn
      state = {[], nil} ->
        {:halt, state}

      state = {[], _next} ->
        fetch_next_deal_page(state)

      state ->
        pop_item(state)
    end

    after_fun = fn _state -> nil end

    Stream.resource(start_fun, next_fun, after_fun)
  end

  defp fetch_next_deal_page({[], next} = state) do
    case HubspotApi.list_deals(next) do
      %HubspotApi.DealList{paging: paging, results: results} when is_map(paging) ->
        pop_item({results, paging.next.link})

      %HubspotApi.DealList{paging: paging, results: results} when is_nil(paging) ->
        pop_item({results, nil})

      {:ok, %{status: 429}} ->
        fetch_next_deal_page(state)
    end
  end

  defp pop_item({[head | tail], next}) do
    new_state = {tail, next}
    {[head], new_state}
  end
end
