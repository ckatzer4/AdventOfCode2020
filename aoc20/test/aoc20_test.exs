defmodule Aoc20Test do
  use ExUnit.Case
  doctest Aoc20

  test "greets the world" do
    assert Aoc20.hello() == :world
  end

  test "parse" do
    {:ok, text} = File.read("input.test")
    tiles = Aoc20.parse(text)
    assert length(Map.keys(tiles)) == 9
    IO.puts("")
    Tile.print(tiles[2311])
    IO.puts("")

    Tile.flip(tiles[2311], :horizontal)
    |> Tile.print()

    Tile.flip(tiles[2311], :horizontal)
    |> Tile.borders()
    |> IO.inspect()

    # corner tiles have two matches
    # middle tiles have three to four matches
    other_borders =
      Enum.filter(tiles, fn {id, _t} -> id != 1951 end)
      |> Enum.flat_map(fn {_id, tile} ->
        Tile.all_borders(tile)
      end)
      |> MapSet.new()

    len =
      tiles[1951]
      |> Tile.borders()
      |> MapSet.new()
      |> MapSet.intersection(other_borders)
      |> IO.inspect()
      |> MapSet.to_list()
      |> length()

    assert len == 2

    other_borders =
      Enum.filter(tiles, fn {id, _t} -> id != 2311 end)
      |> Enum.flat_map(fn {_id, tile} ->
        Tile.all_borders(tile)
      end)
      |> MapSet.new()

    len =
      tiles[2311]
      |> Tile.borders()
      |> MapSet.new()
      |> MapSet.intersection(other_borders)
      |> IO.inspect()
      |> MapSet.to_list()
      |> length()

    assert len == 3
    Aoc20.part2(tiles)
  end
end
