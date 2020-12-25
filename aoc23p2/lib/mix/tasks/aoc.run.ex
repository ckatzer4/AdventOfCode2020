defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc23p2.parse(text)
    IO.puts(Aoc23p2.part1(series))
    IO.puts(Aoc23p2.part2(series))
  end
end
