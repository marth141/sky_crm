defmodule CopperApi.StatusServer do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would determine and cache the statuses of other collectors.

  Status can be asked for from CopperApi.CopperCollectors
  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  def init(_opts) do
    Messaging.subscribe(CopperApi.topic())
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def set_collector_status(collector_module, status) do
    GenServer.call(__MODULE__, {:set_collector_status, collector_module, status})
  end

  def handle_call(:get_state, _, state) do
    {:reply, state, state}
  end

  def handle_call({:set_collector_status, module, status}, _, state) do
    Messaging.publish(
      "CopperApi",
      {:collector_status_changed, module, status}
    )

    {:reply, :ok, Map.put(state, module, status)}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end
end
