defmodule Aoc6 do
  @moduledoc """
  Documentation for `Aoc6`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc6.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n\n")
  end

  def parse_group1(group) do
    String.replace(group, "\n","")
    # split into a list of graphemes
    |> String.graphemes()
    |> Enum.sort()
    |> Enum.dedup()
    |> length()
  end

  def parse_group2(group) do
    group = String.split(group, "\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    len = length(group)
    # count up answers
    counts =
      Enum.flat_map(group, &String.graphemes/1)
      |> Enum.frequencies()

    # find answers with count == len
    Enum.filter(counts, fn {_k,v} -> v==len end)
    |> Enum.map(fn {_k,_v} -> 1 end)
    |> Enum.sum()
  end

  def part1(groups) do
    groups
    |> Stream.map(&parse_group1/1)
    |> Enum.sum()
  end

  def part2(groups) do
    groups
    |> Stream.map(&parse_group2/1)
    |> Enum.sum()
  end

end
