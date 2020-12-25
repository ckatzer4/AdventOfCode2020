defmodule Aoc25Test do
  use ExUnit.Case
  doctest Aoc25

  test "part1" do
    assert Aoc25.part1({5764801, 17807724}) == 14897079
    assert Aoc25.part1({17807724, 5764801}) == 14897079
  end
end
