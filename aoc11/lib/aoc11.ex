defmodule Aoc11 do
  @moduledoc """
  Documentation for `Aoc11`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc11.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {s, r} ->
      String.graphemes(s)
      |> Enum.with_index()
      |> Enum.map(fn {g, c} -> {{r, c}, g} end)
    end)
    |> Enum.into(%{})
  end

  def part1(seats) do
    SeatEvolver.stabilize(seats)
  end

  def part2(seats) do
    SeatEvolver.stabilize2(seats)
  end
end

defmodule Seats do
  def adjacent(seats, {r, c}) do
    adj_coord = [
      {r - 1, c - 1},
      {r - 1, c},
      {r - 1, c + 1},
      {r, c - 1},
      {r, c + 1},
      {r + 1, c - 1},
      {r + 1, c},
      {r + 1, c + 1}
    ]

    Enum.count(adj_coord, fn coord ->
      Map.get(seats, coord, ".") == "#"
    end)
  end

  def visible(seats, {r, c}) do
    directions = [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, -1},
      {1, 0},
      {1, 1}
    ]

    Enum.map(directions, fn {rd, cd} ->
      Stream.iterate({r+rd, c+cd}, fn {r, c} ->
        {r + rd, c + cd}
      end)
      |> Stream.map(&Map.get(seats, &1))
      |> Stream.take_while(&(&1 != nil))
    end)
    |> Enum.count(fn l ->
      Stream.filter(l, &(&1 != "."))
      |> Enum.at(0) == "#"
    end)
  end

  def print(seats) do
    {rows, cols} =
      Enum.reduce(seats, {0, 0}, fn {coord, _}, max ->
        if coord > max do
          coord
        else
          max
        end
      end)

    0..rows
    |> Enum.each(fn r ->
      Enum.map(0..cols, &{r, &1})
      |> Enum.each(fn coord -> IO.write(seats[coord]) end)

      IO.write("\n")
    end)
  end
end

defmodule SeatEvolver do
  def stabilize(seats, hist \\ []) do
    {rows, cols} =
      Enum.reduce(seats, {0, 0}, fn {coord, _}, max ->
        if coord > max do
          coord
        else
          max
        end
      end)

    next =
      0..rows
      |> Enum.flat_map(fn r -> Enum.map(0..cols, &{r, &1}) end)
      |> Enum.map(fn coord ->
        case seats[coord] do
          "L" ->
            if Seats.adjacent(seats, coord) == 0 do
              {coord, "#"}
            else
              {coord, "L"}
            end

          "#" ->
            if Seats.adjacent(seats, coord) > 3 do
              {coord, "L"}
            else
              {coord, "#"}
            end

          "." ->
            {coord, "."}
        end
      end)
      |> Enum.into(%{})

    if next == seats do
      Enum.map(seats, fn {_, v} -> v end)
      |> Enum.count(&(&1 == "#"))
    else
      SeatEvolver.stabilize(next, [seats | hist])
    end
  end

  def stabilize2(seats) do
    {rows, cols} =
      Enum.reduce(seats, {0, 0}, fn {coord, _}, max ->
        if coord > max do
          coord
        else
          max
        end
      end)

    next =
      0..rows
      |> Enum.flat_map(fn r -> Enum.map(0..cols, &{r, &1}) end)
      |> Enum.map(fn coord ->
        case seats[coord] do
          "L" ->
            if Seats.visible(seats, coord) == 0 do
              {coord, "#"}
            else
              {coord, "L"}
            end

          "#" ->
            if Seats.visible(seats, coord) > 4 do
              {coord, "L"}
            else
              {coord, "#"}
            end

          "." ->
            {coord, "."}
        end
      end)
      |> Enum.into(%{})

    if next == seats do
      Enum.map(seats, fn {_, v} -> v end)
      |> Enum.count(&(&1 == "#"))
    else
      SeatEvolver.stabilize2(next)
    end
  end
end
