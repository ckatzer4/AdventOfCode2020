defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc7.parse(text)
    IO.puts(Aoc7.part1(groups))
    IO.puts(Aoc7.part2(groups))
  end
end
