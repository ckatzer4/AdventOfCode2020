defmodule Aoc2Test do
  use ExUnit.Case
  doctest Aoc2

  test "greets the world" do
    assert Aoc2.hello() == :world
  end

  test "parse_line" do
    assert [[1, 3], 97, "abcde"] = Aoc2.parse_line("1-3 a: abcde")
  end

  test "eval rule1" do
    pass = "1-3 a: abcde"
    fail = "1-3 b: cdefg"
    assert Aoc2.eval_rule1(Aoc2.parse_line(pass))
    assert !Aoc2.eval_rule1(Aoc2.parse_line(fail))
  end

  test "eval rule2" do
    pass = "1-3 a: abcde"
    fail = "1-3 b: cdefg"
    fail2 = "2-9 c: ccccccccc"
    assert Aoc2.eval_rule2(Aoc2.parse_line(pass))
    assert !Aoc2.eval_rule2(Aoc2.parse_line(fail))
    assert !Aoc2.eval_rule2(Aoc2.parse_line(fail2))
  end
end
