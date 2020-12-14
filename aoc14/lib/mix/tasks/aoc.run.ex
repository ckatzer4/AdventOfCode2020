defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc14.parse(text)
    IO.puts(Aoc14.part1(series))
    IO.puts(Aoc14.part2(series))
  end
end
