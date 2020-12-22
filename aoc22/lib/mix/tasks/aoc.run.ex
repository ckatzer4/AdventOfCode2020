defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc22.parse(text)
    IO.puts(Aoc22.part1(series))
    IO.puts(Aoc22.part2(series))
  end
end
