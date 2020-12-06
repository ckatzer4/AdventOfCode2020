defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc3.parse(text)
    IO.puts(Aoc3.part1(groups))
    IO.puts(Aoc3.part2(groups))
  end
end

