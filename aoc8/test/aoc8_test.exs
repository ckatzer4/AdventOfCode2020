defmodule Aoc8Test do
  use ExUnit.Case
  doctest Aoc8

  test "greets the world" do
    assert Aoc8.hello() == :world
  end

  test "part1" do
    text = "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"
    ins = Aoc8.parse(text)
    assert Console.run_until_loop(ins) == {5, 1}
  end

  test "part2" do
    text = "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"
    ins = Aoc8.parse(text)
    assert Console.hack(ins) == {8,7}
  end
end
