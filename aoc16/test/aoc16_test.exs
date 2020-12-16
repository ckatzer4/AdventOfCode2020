defmodule Aoc16Test do
  use ExUnit.Case
  doctest Aoc16

  test "greets the world" do
    assert Aoc16.hello() == :world
  end

  test "part1" do
    text = "class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12"

    {r, t, nearby} = Aoc16.parse(text)
    assert Aoc16.part1({r, t, nearby}) == 71
  end

  test "part2" do
    text = "class: 0-1 or 4-19
row: 0-5 or 8-19
departure seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9"
    t = Aoc16.parse(text)
    assert Aoc16.part2(t) == 13
  end
end
