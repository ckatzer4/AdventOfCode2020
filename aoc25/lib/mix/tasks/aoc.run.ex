defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc25.parse(text)
    IO.puts(Aoc25.part1(series))
    IO.puts(Aoc25.part2(series))
  end
end
