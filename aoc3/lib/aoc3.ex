defmodule Aoc3 do
  @moduledoc """
  Documentation for `Aoc3`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc3.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Enum.filter(fn l -> String.length(l) > 0 end)
    |> Enum.map(&String.to_charlist/1)
  end

  def part1(map) do
    SledMap.check_map(0, 3, 1, map, 0)
  end

  def part2(map) do
    a = SledMap.check_map(0, 1, 1, map, 0)
    b = SledMap.check_map(0, 3, 1, map, 0)
    c = SledMap.check_map(0, 5, 1, map, 0)
    d = SledMap.check_map(0, 7, 1, map, 0)
    e = SledMap.check_map(0, 1, 2, map, 0)
    a * b * c * d * e
  end
end

defmodule SledMap do
  def check_map(c, m, d, [line | map], count) do
    crash = Enum.fetch(line, c) == {:ok, 35}

    count =
      if crash do
        count + 1
      else
        count
      end

    len = length(line)
    c = rem(c + m, len)
    # special case - down two lines
    # doesn't work for d>2
    map =
      if d > 1 and length(map) > 1 do
        tl(map)
      else
        map
      end

    check_map(c, m, d, map, count)
  end

  def check_map(_c, _m, _d, [], count) do
    count
  end
end
