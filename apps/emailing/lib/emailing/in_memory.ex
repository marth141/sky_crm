defmodule Emailing.InMemory do
  @moduledoc """
  Functions to manage emails stored in memory during development.

  Just delegates to Swoosh.Adapters.Local.Storage.Memory, but isn't that a pain to type?
  """
  alias Swoosh.Adapters.Local.Storage.Memory

  defdelegate all, to: Memory
  defdelegate delete_all, to: Memory
  defdelegate get(id), to: Memory
  defdelegate pop(), to: Memory
  defdelegate push(email), to: Memory
end
