defmodule OnedriveApiTest do
  use ExUnit.Case
  doctest OnedriveApi

  test "greets the world" do
    assert OnedriveApi.hello() == :world
  end
end
