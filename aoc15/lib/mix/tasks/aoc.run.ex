defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc15.parse(text)
    IO.puts(Aoc15.part1(series))
    IO.puts(Aoc15.part2(series))
  end
end
