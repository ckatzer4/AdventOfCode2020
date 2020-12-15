defmodule Aoc15 do
  @moduledoc """
  Documentation for `Aoc15`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc15.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, ",")
    |> Enum.map(fn s -> String.replace(s, "\n", "") end)
    |> Enum.with_index()
    |> Enum.map(fn {itm, idx} -> {idx + 1, String.to_integer(itm)} end)
    |> Enum.into(%{})
  end

  def part1(start) do
    Game.find_num(start, 2020)
  end

  def part2(start) do
    Game.find_num(start, 30000000)
  end
end

defmodule Game do
  def find_num(start, idx) do
    inv =
      Enum.map(start, fn {k, v} -> {v, k} end)
      |> Enum.into(%{})

    len = Enum.max(Map.keys(start)) + 1
    # hopefully true?
    start = Map.put(start, len, 0)

    {next, _inv} =
      Enum.reduce((len + 1)..idx, {0, inv}, fn i, {last, inv} ->
        # look at last spoken number
        next =
          case inv[last] do
            nil -> 0
            x -> i - 1 - x
          end

        {next, Map.put(inv, last, i - 1)}
      end)

    next
  end
end
