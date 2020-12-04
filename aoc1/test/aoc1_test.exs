defmodule Aoc1Test do
  use ExUnit.Case
  doctest Aoc1
  doctest RC

  test "greets the world" do
    assert Aoc1.hello() == :world
  end

  test "parse input" do
    text = "1721
979
366
299
675
1456"
    ints = for n <- String.split(text,"\n"), do: String.to_integer(n)
    assert ints == [1721, 979, 366, 299, 675, 1456]
  end

  test "calc" do
    ints = [1721, 979, 366, 299, 675, 1456]
    pairs = for p <- RC.comb(2,ints), do: p
    assert length(pairs) == 15
    pair = Enum.filter(pairs, fn(p) -> Enum.sum(p) == 2020 end)
    assert length(pair) == 1
    [h, t] = hd(pair)
    assert h*t == 514579
  end
    
end
