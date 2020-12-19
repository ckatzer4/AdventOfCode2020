defmodule Aoc19Test do
  use ExUnit.Case
  doctest Aoc19
  doctest Rules

  test "greets the world" do
    assert Aoc19.hello() == :world
  end

  test "parse" do
    text = "0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\"

ababbb
bababa
abbbab
aaabbb
aaaabbb"
    {rules, messages} = Aoc19.parse(text)

    assert rules == %{
             0 => {:series, [4, 1, 5]},
             1 => {:either, [2, 3], [3, 2]},
             2 => {:either, [4, 4], [5, 5]},
             3 => {:either, [4, 5], [5, 4]},
             4 => {:char, "a"},
             5 => {:char, "b"}
           }

    assert messages == [
             "ababbb",
             "bababa",
             "abbbab",
             "aaabbb",
             "aaaabbb"
           ]

    gr = Rules.graph(rules, 0)
    |> IO.inspect()
    Rules.options(tl(gr), [hd(gr)])
    |> IO.inspect()
  end

  test "part1" do
    text = "0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\"

ababbb
bababa
abbbab
aaabbb
aaaabbb"
    {rules, messages} = Aoc19.parse(text)
    assert Aoc19.part1({rules, messages}) == 2
  end
end
