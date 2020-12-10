defmodule Aoc10Test do
  use ExUnit.Case
  doctest Aoc10

  test "greets the world" do
    assert Aoc10.hello() == :world
  end

  test "short ex" do
    text = "16
10
15
5
1
11
7
19
6
12
4"
    a = Aoc10.parse(text)
    assert Aoc10.part1(a) == 35
    assert Aoc10.part2(a) == 8
  end

  test "long ex" do
    text = "28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3"
    a = Aoc10.parse(text)
    assert Aoc10.part1(a) == 220
    assert Aoc10.part2(a) == 19208
  end
end
