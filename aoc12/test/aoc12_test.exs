defmodule Aoc12Test do
  use ExUnit.Case
  doctest Aoc12

  test "greets the world" do
    assert Aoc12.hello() == :world
  end

  test "part1" do
    text = "F10
N3
F7
R90
F11"
    ins = Aoc12.parse(text)
    assert Aoc12.part1(ins) == 25
  end

  test "part2" do
    text = "F10
N3
F7
R90
F11"
    ins = Aoc12.parse(text)
    assert Aoc12.part2(ins) == 286
  end
end
