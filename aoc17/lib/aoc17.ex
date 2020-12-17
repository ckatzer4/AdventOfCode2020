defmodule Aoc17 do
  @moduledoc """
  Documentation for `Aoc17`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc17.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {s, x} ->
      String.graphemes(s)
      |> Enum.with_index()
      |> Enum.map(fn {g, y} -> {g, x, y} end)
    end)
    |> Enum.filter(fn {g, _x, _y} ->
      case g do
        "#" -> true
        _ -> false
      end
    end)
    |> Enum.map(fn {_g, x, y} -> {{x, y, 0, nil}, true} end)
    |> Enum.into(%{})
  end

  def part1(space) do
    Enum.reduce(1..6, space, fn _i, space -> Conway.step(space) end)
    |> Map.keys()
    |> length
  end

  def part2(space) do
    # now entering the fourth dimension
    space = Enum.map(space, fn {{x,y,z,nil},v} -> {{x,y,z,0},true} end)
    |> Enum.into(%{})
    Enum.reduce(1..6, space, fn _i, space -> Conway.step(space) end)
    |> Map.keys()
    |> length
  end
end

defmodule Conway do
  def step(start) do
    space =
      Map.keys(start)
      |> Enum.flat_map(&neighbors/1)
      |> Enum.concat(Map.keys(start))
      |> Enum.uniq()

    Enum.filter(space, fn coord ->
      case Map.get(start, coord, false) do
        true -> live?(start, coord)
        false -> born?(start, coord)
      end
    end)
    |> Enum.map(&{&1, true})
    |> Enum.into(%{})
  end

  def born?(start, coord) do
    count_live(start, coord) == 3
  end

  def live?(start, coord) do
    count = count_live(start, coord)
    count > 1 and count < 4
  end

  def count_live(start, coord) do
    neighbors(coord)
    |> Enum.filter(&Map.get(start, &1, false))
    |> Enum.count()
  end

  def print_space(space) do
    # need min and max for x, y, and z
    {minz, maxz} =
      Map.keys(space)
      |> Enum.map(fn {_, _, z, nil} -> z end)
      |> Enum.min_max()

    Enum.each(minz..maxz, &print_slice(space, &1))
    space
  end

  def print_slice(space, z) do
    {miny, maxy} =
      Map.keys(space)
      |> Enum.map(fn {_, y, _, nil} -> y end)
      |> Enum.min_max()

    {minx, maxx} =
      Map.keys(space)
      |> Enum.map(fn {x, _, _, nil} -> x end)
      |> Enum.min_max()

    IO.puts("z=#{z}")

    Enum.map(minx..maxx, fn x -> for y <- miny..maxy, do: {x, y, z, nil} end)
    |> Enum.map(&print_line(space, &1))

    IO.puts("")
  end

  def print_line(space, line) do
    # print a line (constant x and z) from the space
    line =
      Enum.map(line, fn c ->
        case Map.get(space, c, false) do
          true -> "#"
          false -> "."
        end
      end)
      |> Enum.reduce(&(&2 <> &1))

    IO.puts(line)
  end

  def neighbors({x, y, z, nil}) do
    diffs = [-1, 0, 1]

    Enum.map(diffs, &(x + &1))
    |> Enum.flat_map(fn x -> for d <- diffs, do: {x, y + d} end)
    |> Enum.flat_map(fn {x, y} -> for d <- diffs, do: {x, y, z + d, nil} end)
    |> Enum.filter(&(&1 != {x, y, z, nil}))
  end

  def neighbors({x, y, z, w}) do
    diffs = [-1, 0, 1]

    Enum.map(diffs, &(x + &1))
    |> Enum.flat_map(fn x -> for d <- diffs, do: {x, y + d} end)
    |> Enum.flat_map(fn {x, y} -> for d <- diffs, do: {x, y, z + d} end)
    |> Enum.flat_map(fn {x, y, z} -> for d <- diffs, do: {x, y, z, w + d} end)
    |> Enum.filter(&(&1 != {x, y, z, w}))
  end
end
