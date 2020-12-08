defmodule Aoc8 do
  @moduledoc """
  Documentation for `Aoc8`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc8.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Stream.filter(fn s -> String.length(s) >0 end)
    |> Stream.map(fn s -> String.split(s) end)
    |> Stream.map(fn [ins, val] -> {String.to_atom(ins), String.to_integer(val)} end)
    |> Enum.into([])
  end

  def part1(ins) do
    {acc, _line} = Console.run_until_loop(ins)
    acc
  end

  def part2(ins) do
    {acc, _line} = Console.hack(ins)
    acc
  end
  
end

defmodule Console do
  def run_until_loop(instructions, acc \\ 0, line \\ 0, hist \\ []) do
    if Enum.member?(hist, line) do
      {acc, line}
    else
      # get instruction
      ins = Enum.at(instructions, line)
      # add line to history
      hist = [line | hist]
      # evaluate
      case ins do
        {:nop, _} ->
          line = line + 1
          run_until_loop(instructions, acc, line, hist)
        {:acc, val} ->
          acc = acc + val
          line = line + 1
          run_until_loop(instructions, acc, line, hist)
        {:jmp, val} ->
          line = line + val
          run_until_loop(instructions, acc, line, hist)
        nil ->
          {acc, line}
      end
    end
  end

  def hack(instructions, jmps \\[]) do
    # brute force changing jmps until program exits with line>length(instructions)
    changes = Enum.with_index(instructions)
    |> Enum.filter(fn {{ins, _val}, _index} -> ins == :jmp or ins == :nop  end)
    # find the first untested jmp
    {{ins, val}, line} = Enum.find(changes, fn {_, line} -> line not in jmps end)
    # switch nop and jmp at line
    test = case ins do
      :jmp ->
        List.replace_at(instructions, line, {:nop, val})
      :nop ->
        List.replace_at(instructions, line, {:jmp, val})
    end
    {acc, finish} = run_until_loop(test)
    if finish >= length(instructions) do
      # we did it!
      {acc, line}
    else
      # keep looping
      hack(instructions, [line | jmps])
    end
  end
end
