defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    {:ok, text} = File.read("input")
    series = Aoc13.parse(text)
    IO.puts(Aoc13.part1(series))
    IO.puts(Aoc13.part2(series))
  end
end
