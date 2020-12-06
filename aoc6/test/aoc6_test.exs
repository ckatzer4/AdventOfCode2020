defmodule Aoc6Test do
  use ExUnit.Case
  doctest Aoc6

  test "greets the world" do
    assert Aoc6.hello() == :world
  end

  test "parse input" do
    text = "abc

a
b
c

ab
ac

a
a
a
a

b"
    assert Aoc6.parse(text) == ["abc", "a\nb\nc", "ab\nac", "a\na\na\na", "b"]
  end

  test "part1" do
    answers = ["abc", "a\nb\nc", "ab\nac", "a\na\na\na", "b"]
    assert Aoc6.part1(answers) == 11
  end

  test "part2" do
    text = "abc

a
b
c

ab
ac

a
a
a
a

b"
    assert Aoc6.part2(Aoc6.parse(text)) == 6
  end
end
