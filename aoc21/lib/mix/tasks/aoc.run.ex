defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc21.parse(text)
    IO.puts(Aoc21.part1(series))
    IO.puts(Aoc21.part2(series))
  end
end
