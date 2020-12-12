defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc12.parse(text)
    IO.puts(Aoc12.part1(series))
    IO.puts(Aoc12.part2(series))
  end
end
