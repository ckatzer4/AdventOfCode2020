defmodule Aoc5 do
  @moduledoc """
  Documentation for `Aoc5`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc5.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Stream.filter(fn s -> String.length(s) > 0 end)
    |> Enum.into([])
  end

  def part1(codes) do
    codes
    |> Stream.map(&Seat.search/1)
    |> Stream.map(fn {:ok, row, col} -> row * 8 + col end)
    |> Enum.max()
  end

  def part2(codes) do
    seats =
      0..127
      |> Enum.flat_map(fn r -> for c <- 0..7, do: {r, c} end)

    seats =
      codes
      |> Stream.map(&Seat.search/1)
      |> Enum.reduce(seats, fn {:ok, r, c}, seats -> List.delete(seats, {r, c}) end)

    # find seats without full rows
    rows =
      Enum.reduce(seats, %{}, fn {r, c}, acc ->
        Map.update(acc, r, [c], fn l -> [c | l] end)
      end)

    {r, [c]} = Enum.find(rows, fn {_k, v} -> length(v) == 1 end)
    # IO.inspect({r,c})
    r * 8 + c
  end
end

defmodule Seat do
  def search(code) do
    search_inner(String.graphemes(code))
  end

  @doc """
  Evaluate the boarding pass code.

  Recursive search, each time taking the first grapheme
  and reducing either the row or col range by half.
  """
  def search_inner(code, lrow \\ 0, hrow \\ 127, lcol \\ 0, hcol \\ 7)

  def search_inner([h | t], lrow, hrow, lcol, hcol) do
    # IO.inspect({h, t, lrow, hrow, lcol, hcol})
    case h do
      "F" ->
        mid = Integer.floor_div(hrow - lrow, 2) + 1
        hrow = hrow - mid
        search_inner(t, lrow, hrow, lcol, hcol)

      "B" ->
        mid = Integer.floor_div(hrow - lrow, 2) + 1
        lrow = lrow + mid
        search_inner(t, lrow, hrow, lcol, hcol)

      "L" ->
        mid = Integer.floor_div(hcol - lcol, 2) + 1
        hcol = hcol - mid
        search_inner(t, lrow, hrow, lcol, hcol)

      "R" ->
        mid = Integer.floor_div(hcol - lcol, 2) + 1
        lcol = lcol + mid
        search_inner(t, lrow, hrow, lcol, hcol)

      _ ->
        # invalid grapheme, quit early
        search_inner("", lrow, hrow, lcol, hcol)
    end
  end

  def search_inner([], lrow, hrow, lcol, hcol) do
    # once out of graphemes, validate and return
    if lrow == hrow and lcol == hcol do
      {:ok, lrow, lcol}
    else
      {:err, nil, nil}
    end
  end
end

{:ok, text} = File.read("input")
codes = Aoc5.parse(text)
IO.puts(Aoc5.part1(codes))
IO.puts(Aoc5.part2(codes))
