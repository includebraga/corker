defmodule CorkerTest do
  use ExUnit.Case
  doctest Corker

  test "greets the world" do
    assert Corker.hello() == :world
  end
end
