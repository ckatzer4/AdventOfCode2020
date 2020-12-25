defmodule Aoc23p2Test do
  use ExUnit.Case
  doctest Aoc23p2

  test "part1" do
    cups = Aoc23p2.parse("389125467")
    assert Aoc23p2.part1(cups, 10) == "92658374"
  end

  @tag timeout: :infinity
  test "part2" do
    cups = Aoc23p2.parse("389125467")
    assert Aoc23p2.part2(cups) == 149245887792
  end
end
