defmodule Aoc3Test do
  use ExUnit.Case
  doctest Aoc3

  test "greets the world" do
    assert Aoc3.hello() == :world
  end

  test "map1" do
    text = "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"
    map = Aoc3.parse(text)
    assert SledMap.check_map(0, 3, 1, map, 0) == 7
    assert Aoc3.part1(map) == 7
  end

  test "map2" do
    text = "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"
    map = Aoc3.parse(text)
    assert SledMap.check_map(0, 1, 1, map, 0) == 2
    assert SledMap.check_map(0, 3, 1, map, 0) == 7
    assert SledMap.check_map(0, 5, 1, map, 0) == 3
    assert SledMap.check_map(0, 7, 1, map, 0) == 4
    assert SledMap.check_map(0, 1, 2, map, 0) == 2
  end
end
