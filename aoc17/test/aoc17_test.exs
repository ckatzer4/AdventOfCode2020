defmodule Aoc17Test do
  use ExUnit.Case
  doctest Aoc17

  test "greets the world" do
    assert Aoc17.hello() == :world
  end

  test "conway space" do
    init = %{
      {2, 0, 0, nil} => true,
      {2, 1, 0, nil} => true,
      {0, 1, 0, nil} => true,
      {1, 2, 0, nil} => true,
      {2, 2, 0, nil} => true
    }

    Conway.print_space(init)
    Conway.step(init) |> Conway.print_space()
    count = Conway.step(init) |> Map.keys() |> length()
    assert count == 11
  end

  test "parse" do
    text = ".#.
..#
###"

    init = %{
      {2, 0, 0, nil} => true,
      {2, 1, 0, nil} => true,
      {0, 1, 0, nil} => true,
      {1, 2, 0, nil} => true,
      {2, 2, 0, nil} => true
    }

    assert Aoc17.parse(text) == init
  end

  test "part1" do
    text = ".#.
..#
###"
    init = Aoc17.parse(text)
    assert Aoc17.part1(init) == 112
  end

  test "part2" do
    text = ".#.
..#
###"
    init = Aoc17.parse(text)
    assert Aoc17.part2(init) == 848
  end
end
