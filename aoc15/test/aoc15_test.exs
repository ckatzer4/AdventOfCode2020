defmodule Aoc15Test do
  use ExUnit.Case
  doctest Aoc15

  test "greets the world" do
    assert Aoc15.hello() == :world
  end

  test "part1" do
    text = "0,3,6"
    start = Aoc15.parse(text)
    # assert Game.find_num(start, 4) == 0
    assert Game.find_num(start, 5) == 3
    assert Game.find_num(start, 6) == 3
    assert Game.find_num(start, 7) == 1
    assert Game.find_num(start, 8) == 0
    assert Game.find_num(start, 9) == 4
    assert Game.find_num(start, 10) == 0
    assert Aoc15.part1(start) == 436
  end
end
