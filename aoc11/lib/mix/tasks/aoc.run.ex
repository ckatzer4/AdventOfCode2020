defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc11.parse(text)
    IO.puts(Aoc11.part1(series))
    IO.puts(Aoc11.part2(series))
  end
end
