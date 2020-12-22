defmodule Aoc20 do
  @moduledoc """
  Documentation for `Aoc20`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc20.hello()
      :world

  """
  def hello do
    :world
  end

  def part1(tiles) do
    Tiles.find_corners(tiles)
    |> Enum.reduce(1, fn {id, _}, product -> product * id end)
  end

  def part2(tiles) do
    # fill in the map, starting with a corner.
    # Orient the corner so the south and east borders will fit with future pieces
    # brute force matches, removing from the pool of tiles and adding to the map
    {init, initial_borders} =
      Tiles.find_corners(tiles)
      |> Enum.at(3)

    edges = Tiles.find_edges(tiles)
    |> Enum.map(fn {id, _} -> tiles[id] end)

    Tile.print(tiles[init])
    IO.inspect(initial_borders)

    new_borders = [
      {:west, for(r <- 0..9, do: {r, 9})},
      {:north, for(c <- 0..9, do: {9, c})}
    ]

    map = %{}
    map = Enum.reduce(tiles[init] |> Tile.flip(:vertical) |> Tile.flip(:horizontal), map, fn {{r, c}, _}, map -> Map.put(map, {r, c}, "#") end)
    {_, tiles} = Map.pop(tiles, init)


    # map = TreasureMap.loop(map, edges, new_borders)
    # |> IO.inspect()

    map =
      TreasureMap.loop(map, Map.values(tiles), new_borders)
      |> IO.inspect()

    nil
  end

  def parse(text) do
    String.split(text, "\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
    |> Enum.into(%{})
  end

  def parse_tile(tile) do
    {[id], tile} =
      String.split(tile, "\n", trim: true)
      |> Enum.split(1)

    id =
      String.slice(id, 5, 4)
      |> String.to_integer()

    # find coord for "#" in tile
    tile =
      tile
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.map(fn {g, col} -> {{row, col}, g} end)
      end)
      |> Enum.filter(fn {_coord, g} -> g == "#" end)
      |> Enum.into(%{})

    {id, tile}
  end
end

defmodule Tile do
  def borders(tile) do
    lo_row = Enum.map(0..9, &Map.get(tile, {0, &1}, "."))
    hi_row = Enum.map(0..9, &Map.get(tile, {9, &1}, "."))
    lo_col = Enum.map(0..9, &Map.get(tile, {&1, 0}, "."))
    hi_col = Enum.map(0..9, &Map.get(tile, {&1, 9}, "."))
    # {N, S, W, E}
    [lo_row, hi_row, lo_col, hi_col]
  end

  def all_borders(tile) do
    left = borders(tile)

    right =
      borders(tile)
      |> Enum.map(&Enum.reverse/1)

    Enum.concat(left, right)
  end

  def flip(tile, dir) do
    case dir do
      :horizontal ->
        flip = Enum.zip(0..9, 9..0) |> Enum.into(%{})

        Map.keys(tile)
        |> Enum.map(fn {r, c} -> {{flip[r], c}, "#"} end)
        |> Enum.into(%{})

      :vertical ->
        flip = Enum.zip(0..9, 9..0) |> Enum.into(%{})

        Map.keys(tile)
        |> Enum.map(fn {r, c} -> {{r, flip[c]}, "#"} end)
        |> Enum.into(%{})
    end
  end

  def rotate(tile) do
    # rotate 90 degrees clockwise at a time
    # col 3 -> row 3
    # row 1 -> col 8
    flip = Enum.zip(0..9, 9..0) |> Enum.into(%{})

    Map.keys(tile)
    |> Enum.map(fn {r, c} -> {{c, flip[r]}, "#"} end)
    |> Enum.into(%{})
  end

  def print(tile) do
    Enum.map(0..9, fn r ->
      Enum.map(0..9, &Map.get(tile, {r, &1}, "."))
      |> Enum.reduce(&(&2 <> &1))
      |> IO.puts()
    end)
  end
end

defmodule Tiles do
  def find_corners(tiles) do
    Enum.map(tiles, fn {id, tile} ->
      other_borders =
        Enum.filter(tiles, fn {i, _t} -> i != id end)
        |> Enum.flat_map(fn {_, t} -> Tile.all_borders(t) end)
        |> MapSet.new()

      matching_borders =
        Tile.borders(tile)
        |> MapSet.new()
        |> MapSet.intersection(other_borders)
        |> MapSet.to_list()

      {id, matching_borders}
    end)
    |> Enum.filter(fn {_, borders} -> length(borders) == 2 end)
  end

  def find_edges(tiles) do
    Enum.map(tiles, fn {id, tile} ->
      other_borders =
        Enum.filter(tiles, fn {i, _t} -> i != id end)
        |> Enum.flat_map(fn {_, t} -> Tile.all_borders(t) end)
        |> MapSet.new()

      matching_borders =
        Tile.borders(tile)
        |> MapSet.new()
        |> MapSet.intersection(other_borders)
        |> MapSet.to_list()

      {id, matching_borders}
    end)
    |> Enum.filter(fn {_, borders} -> length(borders) == 3 end)
  end
end

defmodule TreasureMap do
  def line_up(map, tile, {side, coords}) do
    # map - reference tile, already placed
    # coords - coordinates for map border to match, direction matters!
    # tile - tile to orient
    # side - side of tile to match border (should only be :west or :north)
    border = Enum.map(coords, &Map.get(map, &1, "."))

    scenario =
      Tile.all_borders(tile)
      |> Enum.find_index(&(&1 == border))

    case scenario do
      nil ->
        # no match means dead-end
        {:miss, map, []}

      _ ->
        # else, re-orient the tile
        tile =
          case {scenario, side} do
            # north & north, no changes
            {0, :north} ->
              # IO.inspect({0, :north})
              tile

            # north matches, but needs to be west
            {0, :west} ->
              # IO.inspect({0, :west})
              # rotate and flip across vertical
              Tile.rotate(tile) |> Tile.flip(:vertical)

            # south matches, but needs to be north
            {1, :north} ->
              # IO.inspect({1, :north})
              # flip across horizontal
              Tile.flip(tile, :horizontal)

            # south matches, but needs to be west
            {1, :west} ->
              # IO.inspect({1, :west})
              # rotate once
              Tile.rotate(tile)

            # west matches, but needs to be north
            {2, :north} ->
              # IO.inspect({2, :north})
              # rotate and flip across vertical
              Tile.rotate(tile) |> Tile.flip(:vertical)

            # west & west, no changes
            {2, :west} ->
              # IO.inspect({2, :west})
              tile

            # east matches, but needs to be north
            {3, :north} ->
              # IO.inspect({3, :north})
              # rotate three times!
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # east matches, but needs to be west
            {3, :west} ->
              # IO.inspect({3, :west})
              Tile.flip(tile, :vertical)

            # north reverse needs to match north
            {4, :north} ->
              # IO.inspect({4, :north})
              Tile.flip(tile, :vertical)

            # north reverse needs to match west
            {4, :west} ->
              # IO.inspect({4, :west})
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # south reverse needs to match north
            {5, :north} ->
              # IO.inspect({5, :north})
              Tile.flip(tile, :horizontal) |> Tile.flip(:vertical)

            # south reverse needs to match west
            {5, :west} ->
              # IO.inspect({5, :west})
              tile |> Tile.rotate()

            # west reverse needs to match north
            {6, :north} ->
              # IO.inspect({6, :north})
              tile |> Tile.rotate()

            # west reverse needs to match west
            {6, :west} ->
              # IO.inspect({7, :west})
              Tile.flip(tile, :horizontal)

            # east reverse
            {7, :north} ->
              # IO.inspect({7, :north})
              Tile.flip(tile, :vertical) |> Tile.rotate()

            # east reverse
            {7, :west} ->
              # IO.inspect({7, :west})
              Tile.flip(tile, :horizontal) |> Tile.flip(:vertical)

            # no match means we hit an edge
            _ ->
              IO.puts("Oh no you messed up!")
              {map, []}
          end

        # validate tile fits on both edges
        {r_offset, c_offset} = hd(coords)
        # |> IO.inspect()
        validate_borders =
          case {r_offset, c_offset} do
            {0, 0} ->
              []

            {_, 0} ->
              [{:north, for(c <- 0..9, do: {r_offset, c + c_offset})}]

            {0, _} ->
              [{:west, for(r <- 0..9, do: {r + r_offset, c_offset})}]

            _ ->
              [
                {:west, for(r <- 0..9, do: {r + r_offset, c_offset})},
                {:north, for(c <- 0..9, do: {r_offset, c + c_offset})}
              ]
          end

        if !Enum.all?(validate_borders, &validate?(map, tile, &1)) do
          TreasureMap.print(map)
          IO.inspect(validate_borders)
          {:fail}
        else
          # add tile to map and track new borders
          new_borders = [
            {:west, for(r <- 0..9, do: {r + r_offset, c_offset + 9})},
            {:north, for(c <- 0..9, do: {r_offset + 9, c + c_offset})}
          ]

          map =
            Enum.reduce(tile, map, fn {{r, c}, _}, map ->
              Map.put(map, {r + r_offset, c + c_offset}, "#")
            end)

          {:hit, map, new_borders}
        end
    end
  end

  defp validate?(map, tile, {direction, coords}) do
    Tile.print(tile)
    case direction do
      :north ->
        from_map = Enum.map(coords, &Map.get(map, &1, "."))
        from_tile = Enum.map(for(c <- 0..9, do: {0, c}), &Map.get(tile, &1, "."))
        (from_map == from_tile) or (from_map = [".", ".", ".", ".", ".", ".", ".", ".", ".", "."])

      :west ->
        from_map = Enum.map(coords, &Map.get(map, &1, "."))
        from_tile = Enum.map(for(r <- 0..9, do: {r, 0}), &Map.get(tile, &1, "."))
        (from_map == from_tile) or (from_map = [".", ".", ".", ".", ".", ".", ".", ".", ".", "."])
    end
  end

  def loop(map, [t | tiles], borders) do
    # IO.inspect({length([t | tiles]), length(borders)})
    # map and borders should be initialized
    # for each tile, try to fit in one of the borders
    # on hit, drop tile and border
    if length(tiles) == 19 do
      # Tile.print(t)
      # IO.puts("")
    end

    case loop_borders(map, t, borders) do
      {:hit, map, new, old} ->
        IO.puts("We fit this tile:")
        Tile.print(t)
        # IO.puts("Removing this border:")
        # IO.inspect(old)
        # IO.puts("Adding these borders:")
        # IO.inspect(new)
        TreasureMap.print(map)
        # borders = List.delete(borders, old)
        loop(map, tiles, new ++ borders)

      {:miss} ->
        # ran out of borders to test, move tile to end and keep looping
        # IO.puts("Tile didn't fit, so looping around")
        # IO.inspect(borders)
        loop(map, tiles ++ [t], borders)
    end
  end

  def loop(map, [], _) do
    map
  end

  defp loop_borders(map, t, [b | borders]) do
    case line_up(map, t, b) do
      {:hit, map, new} -> {:hit, map, new, b}
      {:miss, map, []} -> loop_borders(map, t, borders)
    end
  end

  defp loop_borders(map, _, []) do
    {:miss}
  end

  def print(map) do
    {r_min, r_max} = Map.keys(map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max() |> IO.inspect()
    {c_min, c_max} = Map.keys(map) |> Enum.map(fn {_, c} -> c end) |> Enum.min_max() |> IO.inspect()

    Enum.map(r_min..r_max, fn r ->
      Enum.map(c_min..c_max, &Map.get(map, {r, &1}, "."))
      |> Enum.reduce(&(&2 <> &1))
      |> IO.puts()
    end)
  end
end
