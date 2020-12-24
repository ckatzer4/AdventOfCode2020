defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc24.parse(text)
    IO.puts(Aoc24.part1(series))
    IO.puts(Aoc24.part2(series))
  end
end
