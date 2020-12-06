defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc6.parse(text)
    IO.puts(Aoc6.part1(groups))
    IO.puts(Aoc6.part2(groups))
  end
end

