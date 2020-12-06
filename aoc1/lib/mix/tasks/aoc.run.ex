defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc1.parse(text)
    IO.puts(Aoc1.part1(groups))
    IO.puts(Aoc1.part2(groups))
  end
end

