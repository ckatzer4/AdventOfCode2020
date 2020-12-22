defmodule Aoc22Test do
  use ExUnit.Case
  doctest Aoc22

  test "greets the world" do
    assert Aoc22.hello() == :world
  end

  test "part1" do
    text = "Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10"
    {p1, p2} = Aoc22.parse(text)
    assert Aoc22.part1({p1, p2}) == 306
    assert Aoc22.part2({p1, p2}) == 291
  end
end
