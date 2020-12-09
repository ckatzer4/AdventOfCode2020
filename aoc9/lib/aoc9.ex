defmodule Aoc9 do
  @moduledoc """
  Documentation for `Aoc9`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc9.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Stream.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s -> String.to_integer(s) end)
  end

  def part1(series) do
    Xmas.crack(series, 25)
  end

  def part2(series) do
    [list] = Xmas.hack(series, 25)
    list = Enum.sort(list)
    hd(list) + List.last(list)
  end
end

defmodule Xmas do
  def crack(series, len) do
    preamble = Enum.take(series, len)

    options =
      RC.comb(2, preamble)
      |> Enum.map(&Enum.sum/1)

    test = Enum.at(series, len)

    if test in options do
      [_ | series] = series
      crack(series, len)
    else
      # found the outlier
      test
    end
  end

  def hack(series, len) do
    target = crack(series, len)
    # find some combo of previous numbers that will sum to target
    prev_len = Enum.find_index(series, &(&1 == target))
    prev = Enum.take(series, prev_len)

    3..prev_len
    |> Stream.flat_map(fn l -> Stream.chunk_every(prev, l, 1) end)
    |> Enum.filter(fn s -> Enum.sum(s) == target end)
  end
end

defmodule RC do
  def comb(0, _), do: [[]]
  def comb(_, []), do: []

  def comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end
end
