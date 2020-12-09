defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc9.parse(text)
    IO.puts(Aoc9.part1(series))
    IO.puts(Aoc9.part2(series))
  end
end
