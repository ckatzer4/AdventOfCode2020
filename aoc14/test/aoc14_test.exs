defmodule Aoc14Test do
  use ExUnit.Case
  doctest Aoc14

  test "greets the world" do
    assert Aoc14.hello() == :world
  end

  test "parse" do
    text = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"

    assert Aoc14.parse(text) == [
             {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
             {:mem, {8, 11}},
             {:mem, {7, 101}},
             {:mem, {8, 0}}
           ]
  end

  test "part1" do
    text = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"

    ins = Aoc14.parse(text)
    assert Aoc14.part1(ins) == 165
  end

  test "part2" do
    text = "mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"
    ins = Aoc14.parse(text)
    assert Aoc14.part2(ins) == 208
  end
end
