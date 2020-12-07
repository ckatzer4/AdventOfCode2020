defmodule Aoc7 do
  @moduledoc """
  Documentation for `Aoc7`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc7.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    # creates a map of maps
    # primary key is color of exterior bag
    # secondary key is color of interior bag
    # value is quantity of interior color 
    String.split(text, "\n")
    |> Stream.filter(&(String.length(&1) > 0))
    |> Enum.map(&parse_contents/1)
    |> Enum.into(%{})
  end

  def parse_contents(line) do
    # first capture outer bag color
    [_, {start, len}] = Regex.run(~r/([a-z]+ [a-z]+) bags contain/, line, return: :index)
    ext_color = String.slice(line, start, len)

    # split line
    interiors = String.slice(line, start + len, String.length(line)-start)

    # capture inner bags
    inner_bags =
      Regex.scan(~r/([0-9]+) ([a-z]+ [a-z]+) bag[s ,\.]*/, interiors)
      |> Enum.map(fn [_, num, color] -> {color, String.to_integer(num)} end)
      |> Enum.into(%{})

    {ext_color, inner_bags}
  end

  def part1(rules) do
    Map.keys(rules)
    |> Enum.count(&BagRules.will_contain?(rules, &1, "shiny gold"))
  end

  def part2(rules) do
    BagRules.count_contents(rules, "shiny gold")
  end
end

defmodule BagRules do
  def will_contain?(rules, exterior, interior) do
    # check if exterior will contain interior
    # we only care about color, not quantity
    contents =
      Map.get(rules, exterior)
      |> Enum.map(fn {color, _q} -> color end)

    cond do
      Enum.member?(contents, interior) -> true
      Enum.any?(contents, &will_contain?(rules, &1, interior)) -> true
      true -> false
    end
  end

  def count_contents(rules, color) do
    {count, contents} =
      Map.get(rules, color)
      |> Enum.reduce({0, []}, fn {k, v}, {count, contents} ->
        {count + v, List.duplicate(k, v) ++ contents}
      end)

    case contents do
      [] ->
        0

      contents ->
        count + (Enum.map(contents, &count_contents(rules, &1)) |> Enum.sum())
    end
  end
end
