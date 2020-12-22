defmodule Aoc21 do
  @moduledoc """
  Documentation for `Aoc21`.
  """

  defp options({ings, algs}) do
    uniq_alg = Enum.reduce(algs, MapSet.new(), fn l, set ->
      MapSet.new(l)
      |> MapSet.union(set)
    end)
    |> MapSet.to_list()
    |> IO.inspect()

    Enum.map(uniq_alg, fn alg -> 
      o = Enum.zip(ings, algs)
      |> Enum.filter(fn {_, a} -> Enum.member?(a, alg) end)
      |> Enum.map(fn {i, _} -> MapSet.new(i) end)
      |> Enum.reduce(fn i, set ->
        MapSet.intersection(set, i)
      end)
      {alg, o}
    end)
    |> Enum.into(%{})
    |> IO.inspect()
  end

  def part1({ings, algs}) do
    all_ingredients = Enum.reduce(ings, &(&2++&1))
    |> IO.inspect()

    options = options({ings, algs})

    Enum.count(all_ingredients, fn i ->
      found = Map.values(options)
      |> Enum.map(&(i in &1))
      |> Enum.any?()
      !found
    end)
  end

  def part2({ings, algs}) do
    options = options({ings, algs})
    # need to solve which ingredient contains which allergen
    solved = Enum.sort_by(options, fn {_, o} -> Enum.count(o) end)
    |> Enum.reduce(%{}, fn {n, o}, solved ->
      used = Map.values(solved)
      |> MapSet.new()

      o = MapSet.difference(o, used)
      |> MapSet.to_list()
      Map.put(solved, n, hd(o))
    end)
    |> IO.inspect()

    Enum.sort_by(solved, fn {k, _} -> k end)
    |> Enum.map(fn {_,v} -> v end)
    |> Enum.join(",")
  end

  def parse(text) do
    alrgn_re = ~r/\(contains ([a-z]*(, [a-z]*)*)\)/
    ing = String.split(text, "\n", trim: true)
    |> Enum.map(&parse_ing/1)

    alg = String.split(text, "\n", trim: true)
    |> Enum.map(&Regex.run(alrgn_re, &1, capture: :all_but_first))
    |> Enum.map(fn [s | _] -> String.split(s, ", ") end)

    {ing, alg}
  end

  def parse_ing(line) do
    String.split(line, " ")
    |> Enum.take_while(fn w -> !String.contains?(w, "(") end)
  end
end
