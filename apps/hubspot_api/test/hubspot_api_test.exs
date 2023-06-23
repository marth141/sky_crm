defmodule HubspotApiTest do
  use ExUnit.Case
  doctest HubspotApi

  test "greets the world" do
    assert HubspotApi.hello() == :world
  end
end
