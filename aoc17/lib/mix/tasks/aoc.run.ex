defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc17.parse(text)
    IO.puts(Aoc17.part1(series))
    IO.puts(Aoc17.part2(series))
  end
end
