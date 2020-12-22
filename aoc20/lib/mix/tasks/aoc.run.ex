defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc20.parse(text)
    IO.puts(Aoc20.part1(series))
    IO.puts(Aoc20.part2(series))
  end
end
