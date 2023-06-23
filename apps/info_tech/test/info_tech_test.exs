defmodule InfoTechTest do
  use ExUnit.Case
  doctest InfoTech

  test "greets the world" do
    assert InfoTech.hello() == :world
  end
end
