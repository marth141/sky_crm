defmodule Messaging do
  defp pub_sub, do: Messaging.PubSub

  @doc """
  Subscribe to a topic.

  By convention this is usually wrapped by the context boundary of an application to constrain or support subscriptions to that context.

  ### Example

  ```elixir
  :ok = Messaging.subscribe("some-topic")
  ```
  """
  def subscribe(topic),
    do: Phoenix.PubSub.subscribe(pub_sub(), topic)

  @doc """
  Publish a message to a given topic.

  ### Example

  ```elixir
  :ok = Messaging.publish(:my_message, "some-topic")
  ```
  """
  def publish(topic, message),
    do: Phoenix.PubSub.broadcast(pub_sub(), topic, message)

  def unsubscribe(topic),
    do: Phoenix.PubSub.unsubscribe(pub_sub(), topic)
end
