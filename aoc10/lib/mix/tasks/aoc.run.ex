defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc10.parse(text)
    IO.puts(Aoc10.part1(series))
    IO.puts(Aoc10.part2(series))
  end
end
