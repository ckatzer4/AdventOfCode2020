defmodule Aoc11Test do
  use ExUnit.Case
  doctest Aoc11

  test "greets the world" do
    assert Aoc11.hello() == :world
  end

  test "part1" do
    text = "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"
    seats = Aoc11.parse(text)
    assert Aoc11.part1(seats) == 37
    assert Aoc11.part2(seats) == 26
  end
end
