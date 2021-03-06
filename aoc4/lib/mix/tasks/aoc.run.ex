defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc4.parse(text)
    IO.puts(Aoc4.part1(groups))
    IO.puts(Aoc4.part2(groups))
  end
end

