defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc18.parse(text)
    IO.puts(Aoc18.part1(series))
    IO.puts(Aoc18.part2(series))
  end
end
