defmodule CopperApi.Collectors do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Documentation for CopperApi Collectors endpoint for interacting with the GenServers beyond it.
  """

  def topic(), do: inspect(__MODULE__)

  def subscribe, do: Messaging.subscribe(topic())

  def publish(message),
    do: Messaging.publish(topic(), message)

  def unsubscribe(),
    do: Messaging.unsubscribe(topic())

  alias CopperApi.{Opportunities, Leads, Tasks}

  def get_collector_status(Opportunities) do
    CopperApi.StatusServer.get_state()
    |> Map.get(Opportunities)
  end

  def get_collector_status(Leads) do
    CopperApi.StatusServer.get_state()
    |> Map.get(Leads)
  end

  def get_collector_status(Tasks) do
    CopperApi.StatusServer.get_state()
    |> Map.get(Tasks)
  end
end
