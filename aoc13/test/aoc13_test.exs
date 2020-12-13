defmodule Aoc13Test do
  use ExUnit.Case
  doctest Aoc13

  test "greets the world" do
    assert Aoc13.hello() == :world
  end

  test "part1" do
    text = "939
7,13,x,x,59,x,31,19"
    p = Aoc13.parse(text)
    assert Aoc13.part1(p) == 295
  end

  test "part2" do
    text = "939
7,13,x,x,59,x,31,19"
    p = Aoc13.parse(text)
    assert Aoc13.part2(p) == 1068781
    assert Aoc13.part2({0,"17,x,13,19"}) == 3417
    assert Aoc13.part2({0,"67,7,59,61"}) == 754018
    assert Aoc13.part2({0,"67,x,7,59,61"}) == 779210
    assert Aoc13.part2({0,"67,7,x,59,61"}) == 1261476
    assert Aoc13.part2({0,"1789,37,47,1889"}) == 1202161486
  end

  test "CRT" do
    # from Wikipedia
    assert CRT.find_val([0,3,4],[3,4,5]) == 39
    # from Brilliant
    assert CRT.find_val([1,4,6],[3,5,7]) == 34
  end
    
end
