defmodule Aoc1 do
  @moduledoc """
  Documentation for `Aoc1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc1.hello()
      :world

  """
  def hello do
    :world
  end

  def parse do
    {:ok, text} = File.read("input")

    ints =
      String.split(text, "\n")
      |> Enum.filter(fn s -> String.length(s) > 1 end)
      |> Enum.map(&String.to_integer/1)

    # ints = for n <- String.split(text,"\n"), do: String.to_integer(n)
    ints
  end

  def part1(ints) do
    pairs = for p <- RC.comb(2, ints), do: p
    pair = Enum.filter(pairs, fn p -> Enum.sum(p) == 2020 end)
    [h, t] = hd(pair)
    h * t
  end

  def part2(ints) do
    triples = for t <- RC.comb(3, ints), do: t
    triple = Enum.filter(triples, fn p -> Enum.sum(p) == 2020 end)
    [p1, p2, p3] = hd(triple)
    p1 * p2 * p3
  end
end

defmodule RC do
  def comb(0, _), do: [[]]
  def comb(_, []), do: []

  def comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end
end

ints = Aoc1.parse()
IO.puts(Aoc1.part1(ints))
IO.puts(Aoc1.part2(ints))
