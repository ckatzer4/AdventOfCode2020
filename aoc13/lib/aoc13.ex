defmodule Aoc13 do
  @moduledoc """
  Documentation for `Aoc13`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc13.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    # first line is starting timestamp
    # second line is available buses (igmore x)
    lines = String.split(text, "\n")
    start = Enum.at(lines,0) |> String.to_integer()
    buses = 
      Enum.at(lines, 1)
    {start, buses}
  end

  def part1({start, buses}) do
    buses = String.split(buses, ",")
      |> Stream.filter(fn s -> s != "x" end)
      |> Enum.map(fn s -> String.to_integer(s) end)
    {time, bus} = Enum.map(buses, fn bus ->
      Stream.iterate(start, fn t -> t+1 end)
      |> Stream.filter(&(rem(&1, bus) == 0))
      |> Enum.at(0)
    end)
    |> Enum.zip(buses)
    |> Enum.min_by(fn {time, _bus} -> time end)
    (time-start)*bus
  end

  def part2({_t, buses}) do
    {buses, offsets} = String.split(buses, ",")
    |> Enum.with_index()
    |> Enum.filter(fn {bus, _} -> bus != "x" end)
    |> Enum.map(fn {bus,idx} -> {String.to_integer(bus),idx} end)
    # calc offset:
    # smallest positive number such that bus will arrive
    # 'idx' minutes later
    # sometimes 'idx'>'bus', so we can do a terrible modulo hack
    |> Enum.map(fn {bus,idx} -> {bus,rem(10*bus-idx,bus)} end)
    |> Enum.unzip()
    # |> IO.inspect()
    CRT.find_val(offsets, buses)
  end

end

defmodule CRT do
  @moduledoc """
  Implementation of Chinese Remainder Thoerem using sieves.
  """

  @doc """
  Solves the system of equations where:
    X mod moduli[0] = remainders[0]
    X mod moduli[1] = remainders[1]
    ...
    X mod moduli[n-1] = remainders[n-1]
    X mod moduli[n] = remainders[n]
  """
  def find_val(remainders, moduli) do
    # sort remainders and moduli by largest to smallest mod
    {moduli, remainders} = Enum.zip(moduli, remainders)
    |> Enum.sort_by(fn {m, _} -> m end, &>=/2)
    |> Enum.unzip()
    start = hd(remainders)
    step = hd(moduli)
    inner(tl(remainders), tl(moduli), step, start)
  end

  @doc """
  Run each stage of the sieve.

  First stage finds a value that solves the first rwo equations.
  Second stage finds a value that solves the first three; 
  Third for four, etc.
  """
  def inner([], [], _step, result) do
    result
  end

  def inner([r | remainders], [mod | moduli], step, result) do
    # starting from result, increment by step and test
    result = Stream.iterate(result, &(&1+step))
    # |> Stream.map(&IO.inspect/1)
    |> Stream.filter(fn t -> rem(t,mod) == r end)
    # take the first result that passes the test
    |> Enum.at(0)
    inner(remainders, moduli, step*mod, result)
  end
end
