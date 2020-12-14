defmodule Aoc14 do
  @moduledoc """
  Documentation for `Aoc14`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc14.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_ins(ins, value) do
    case ins do
      "mask" ->
        {:mask, value}

      mem ->
        # memory address
        [_, addr] = Regex.run(~r/mem\[(\d*)\]/, mem)
        val = {String.to_integer(addr), String.to_integer(value)}
        {:mem, val}
    end
  end

  def parse(text) do
    String.split(text, "\n")
    |> Stream.filter(fn s -> String.length(s) > 0 end)
    |> Stream.map(fn s -> String.split(s, " = ") end)
    |> Enum.map(fn [ins, val] -> parse_ins(ins, val) end)
  end

  def part1(ins) do
    mem = Memory.init(ins)
    Map.values(mem) |> Enum.sum()
  end

  def part2(ins) do
    mem = MemoryV2.init(ins)
    Map.values(mem) |> Enum.sum()
  end
end

defmodule Memory do
  def init(lines, mask \\ 0, memory \\ %{})

  def init([], _mask, memory) do
    memory
  end

  def init([{ins, val} | lines], mask, memory) do
    case ins do
      :mask ->
        init(lines, make_mask(val), memory)

      :mem ->
        {addr, val} = val
        val = apply_mask(mask, val)
        memory = Map.put(memory, addr, val)
        init(lines, mask, memory)
    end
  end

  defp make_mask(mask) do
    String.graphemes(mask)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.filter(fn {itm, _idx} -> itm != "X" end)
    |> Enum.map(fn {itm, idx} ->
      use Bitwise

      case itm do
        "1" -> {:or, 1 <<< idx}
        "0" -> {:and, bnot(1 <<< idx)}
      end
    end)
  end

  defp apply_mask(mask, val) do
    Enum.reduce(mask, val, fn m, val ->
      use Bitwise

      case m do
        {:or, m} -> m ||| val
        {:and, m} -> m &&& val
      end
    end)
  end
end

defmodule MemoryV2 do
  def init(lines, mask \\ 0, memory \\ %{})

  def init([], _mask, memory) do
    memory
  end

  def init([{ins, val} | lines], mask, memory) do
    case ins do
      :mask ->
        init(lines, make_mask(val), memory)

      :mem ->
        {addr, val} = val
        addrs = apply_mask(mask, addr)
        memory = Enum.reduce(addrs, memory, fn addr, mem -> Map.put(mem, addr, val) end)
        init(lines, mask, memory)
    end
  end

  defp make_mask(mask) do
    String.graphemes(mask)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.filter(fn {itm, _idx} -> itm != "0" end)
    |> Enum.map(fn {itm, idx} ->
      use Bitwise

      case itm do
        "1" -> {:or, 1 <<< idx}
        "X" -> {:flip, 1 <<< idx}
      end
    end)
  end

  defp apply_mask(mask, addr) do
    Enum.reduce(mask, [addr], fn m, addrs ->
      use Bitwise

      case m do
        {:or, m} ->
          Enum.map(addrs, &(m ||| &1))

        {:flip, m} ->
          Enum.flat_map(addrs, fn a ->
            [m ||| a, bnot(m) &&& a]
          end)
      end
    end)
  end
end
