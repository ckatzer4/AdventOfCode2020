defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    groups = Aoc5.parse(text)
    IO.puts(Aoc5.part1(groups))
    IO.puts(Aoc5.part2(groups))
  end
end

