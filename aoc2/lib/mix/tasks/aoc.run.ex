defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc2.parse(text)
    IO.puts(Aoc2.part1(groups))
    IO.puts(Aoc2.part2(groups))
  end
end

