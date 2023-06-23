defmodule AhjRegistryApiTest do
  use ExUnit.Case
  doctest AhjRegistryApi

  test "greets the world" do
    assert AhjRegistryApi.hello() == :world
  end
end
