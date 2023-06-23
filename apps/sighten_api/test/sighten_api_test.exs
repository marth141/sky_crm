defmodule SightenApiTest do
  use ExUnit.Case
  doctest SightenApi

  test "greets the world" do
    assert SightenApi.hello() == :world
  end
end
