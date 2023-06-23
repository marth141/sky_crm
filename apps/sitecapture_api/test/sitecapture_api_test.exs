defmodule SitecaptureApiTest do
  use ExUnit.Case
  doctest SitecaptureApi

  test "greets the world" do
    assert SitecaptureApi.hello() == :world
  end
end
