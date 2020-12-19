defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc19.parse(text)
    IO.puts(Aoc19.part1(series))
    # IO.puts(Aoc19.part2(series))
  end
end
