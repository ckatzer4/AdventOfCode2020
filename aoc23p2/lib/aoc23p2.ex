defmodule Aoc23p2 do
  @moduledoc """
  Documentation for `Aoc23p2`.
  """

  def parse(text) do
    numbers = String.strip(text)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)

    head = hd(numbers)
    {final, cups} =
      Enum.reduce(numbers, {nil, %{}}, fn cup, {prev, cups} ->
        case prev do
          nil -> {cup, cups}
          p -> {cup, Map.put(cups, p, cup)}
        end
      end)
    {Map.put(cups, final, head), head}
  end

  def part1({cups, start}, rounds \\ 100) do
    {cups, _} = 
      Enum.reduce(1..rounds, {cups, start}, fn _, {cups, current} -> 
        Cups.round(cups, current)
      end)
    Enum.reduce(1..8, [1], fn _, stack ->
      start = hd(stack)
      [Cups.next(cups, start) | stack]
    end)
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.join("")
  end

  def part2({cups, start}) do
    # the last cup is 8 after start
    last = Enum.reduce(1..8, start, fn _, prev ->
      Cups.next(cups, prev)
    end)
    # add cups to 1Mil after last
    {cups, _} = Enum.reduce(10..1000000, {cups, last}, fn c, {cups, prev} ->
      {Cups.put_after(cups, prev, c), c}
    end)
    # simulate 10Mil games
    {cups, _} = 
      Enum.reduce(1..10000000, {cups, start}, fn r, {cups, current} -> 
        Cups.round(cups, current)
      end)
    # take two numbers after 1 and multiply
    cups[1] * cups[cups[1]]
  end
end

defmodule Cups do
  def round(cups, current) do
    # take three cups after current
    {cups, stack} = 
      Enum.reduce(1..3, {cups, []}, fn _, {cups, stack} ->
        {cups, take} = Cups.take_after(cups, current)
        {cups, [take | stack]}
      end)

    dest = Cups.find_dest(cups, current)

    cups = Enum.reduce(stack, cups, fn c, cups->
      Cups.put_after(cups, dest, c)
    end)

    {cups, Cups.next(cups, current)}
  end

  def take_after(cups, current) do
    take = cups[current]
    tail = cups[take]
    cups = Map.delete(cups, take)
    |> Map.put(current, tail)
    {cups, take}
  end

  def put_after(cups, dest, c) do
    tail = cups[dest]
    Map.put(cups, dest, c)
    |> Map.put(c, tail)
  end

  def find_dest(cups, 1) do
    Map.keys(cups) |> Enum.max()
  end

  def find_dest(cups, current) do
    dest = current - 1
    if Map.has_key?(cups, dest) do
      dest
    else
      find_dest(cups, dest)
    end
  end

  def next(cups, c) do
    cups[c]
  end
end
