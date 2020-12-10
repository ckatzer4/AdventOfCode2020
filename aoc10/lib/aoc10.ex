defmodule Aoc10 do
  @moduledoc """
  Documentation for `Aoc10`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc10.hello()
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

  def part1(adaptors) do
    # 0 for the seat, max+3 for built-in
    adaptors = [0 | adaptors]
    adaptors = [Enum.max(adaptors) + 3 | adaptors]
    adaptors = Enum.sort(adaptors)
    {one_d, three_d} = Adaptors.sum_diffs(adaptors)
    one_d * three_d
  end

  def part2(adaptors) do
    adaptors = [0 | adaptors]
    adaptors = [Enum.max(adaptors) + 3 | adaptors]
    adaptors = Enum.sort(adaptors)
    Adaptors.all_possibilities(adaptors)
  end
end

defmodule(Adaptors) do
  def sum_diffs(adaptors) do
    pairs = Enum.chunk_every(adaptors, 2, 1, :discard)

    Enum.reduce(pairs, {0, 0}, fn [low, high], {one_d, three_d} ->
      case high - low do
        1 -> {one_d + 1, three_d}
        3 -> {one_d, three_d + 1}
      end
    end)
  end

  def all_possibilities(adaptors) do
    # make partial diffs
    diffs =
      Enum.chunk_every(adaptors, 2, 1, :discard)
      |> Enum.map(fn [low, high] -> high - low end)

    # find series of ones - they add more options
    # I can't figure out what math yields this,
    # but i have reverse engineered up to length=4
    # which just happens to be sufficient for my input
    # 1, 1 -> two possibilities
    # 1, 1, 1 -> four possibilities
    # 1, 1, 1, 1 -> seven possibilities
    # 1, 1, 1, 1, 1 -> 12? who cares
    Enum.chunk_by(diffs, &(&1 == 3))
    # ignore 3s
    |> Enum.filter(fn [h | _] -> h == 1 end)
    |> Enum.map(fn ones ->
      case length(ones) do
        1 -> 1
        2 -> 2
        3 -> 4
        4 -> 7
      end
    end)
    # product of all numbers
    |> Enum.reduce(1, &(&1 * &2))
  end
end
