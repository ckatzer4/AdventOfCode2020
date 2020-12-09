defmodule Aoc9Test do
  use ExUnit.Case
  doctest Aoc9

  test "greets the world" do
    assert Aoc9.hello() == :world
  end

  test "preamble len 5" do
    text = "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"
    series = Aoc9.parse(text)
    assert Xmas.crack(series, 5) == 127
  end

  test "example2" do
    series = Enum.concat([[20], 1..19, 21..25, [65]])
    assert Xmas.crack(series, 25) == 65
  end

  test "part2" do
    text = "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"
    series = Aoc9.parse(text)
    assert Xmas.hack(series, 5) == [[15, 25, 47, 40]]
  end
end
