defmodule ZenefitsApiTest do
  use ExUnit.Case
  doctest ZenefitsApi

  test "greets the world" do
    assert ZenefitsApi.hello() == :world
  end
end
