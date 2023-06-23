defmodule TimeApiTest do
  use ExUnit.Case
  doctest TimeApi

  test "greets the world" do
    assert TimeApi.hello() == :world
  end
end
