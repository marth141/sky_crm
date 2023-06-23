defmodule PandadocApiTest do
  use ExUnit.Case
  doctest PandadocApi

  test "greets the world" do
    assert PandadocApi.hello() == :world
  end
end
