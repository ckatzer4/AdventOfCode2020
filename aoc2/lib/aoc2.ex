defmodule Aoc2 do
  @moduledoc """
  Documentation for `Aoc2`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_line(l) do
    [rule, letter, pass] = String.split(l," ")
    rule = String.split(rule, "-")
           |> Enum.map( &String.to_integer/1 )
    letter = hd(String.to_charlist(letter))
    [rule, letter, pass]
  end

  def eval_rule1(l) do
    [rule, letter, pass] = l
    [low, high] = rule
    count = Enum.count(String.to_charlist(pass), fn(c) -> c == letter end)
    count>=low and count<=high
  end

  def eval_rule2(l) do
    [rule, letter, pass] = l
    [low, high] = rule
    pass = String.to_charlist(pass)
    low = Enum.fetch(pass, low-1) == {:ok, letter}
    high = Enum.fetch(pass, high-1) == {:ok, letter}
    (low and !high) or (!low and high)
  end

  def parse(text) do
    rules = String.split(text, "\n")
            |> Enum.filter( fn(s) -> String.length(s) > 0 end)
            |> Enum.map( &parse_line/1)
    rules
  end

  def part1(rules) do
    Enum.count(rules, &eval_rule1/1)
  end

  def part2(rules) do
    Enum.count(rules, &eval_rule2/1)
  end
end


{:ok, text} = File.read("input")
rules = Aoc2.parse(text)
IO.puts(Aoc2.part1(rules))
IO.puts(Aoc2.part2(rules))
