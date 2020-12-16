defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc16.parse(text)
    IO.puts(Aoc16.part1(series))
    IO.puts(Aoc16.part2(series))
  end
end
