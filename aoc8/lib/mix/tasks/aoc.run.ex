defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc8.parse(text)
    IO.puts(Aoc8.part1(groups))
    IO.puts(Aoc8.part2(groups))
  end
end
