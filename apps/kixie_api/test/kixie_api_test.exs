defmodule KixieApiTest do
  use ExUnit.Case
  doctest KixieApi

  test "greets the world" do
    assert KixieApi.hello() == :world
  end
end
