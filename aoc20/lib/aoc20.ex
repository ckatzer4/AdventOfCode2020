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
    new_borders = [
      {{0, 0}, :north},
      {{0, 0}, :south},
      {{0, 0}, :west},
      {{0, 0}, :east}
    ]

    # tile coord => tile
    map = %{}
    init = Enum.at(Map.keys(tiles), 0)
    map = Map.put(map, {0, 0}, tiles[init])

    {_, tiles} = Map.pop(tiles, init)

    map =
      TileMap.loop(map, Map.values(tiles), new_borders)

    # We found our tile placements!
    map = SeaMap.assemble(map)

    orientations = [
      &(&1),
      &(&1 |> SeaMap.rotate()),
      &(&1 |> SeaMap.rotate() |> SeaMap.rotate() ),
      &(&1 |> SeaMap.rotate() |> SeaMap.rotate() |> SeaMap.rotate() ),
      &(&1 |> SeaMap.flip(:vertical) ),
      &(&1 |> SeaMap.flip(:vertical) |> SeaMap.rotate() ),
      &(&1 |> SeaMap.flip(:vertical) |> SeaMap.rotate() |> SeaMap.rotate() ),
      &(&1 |> SeaMap.flip(:vertical) |> SeaMap.rotate() |> SeaMap.rotate() |> SeaMap.rotate() ),
    ]

    proper = Enum.max_by(orientations, fn o -> SeaMap.find_serpents(o.(map)) |> Enum.count() end)
    map = proper.(map)
    SeaMap.remove_serpents(map)
    |> Enum.count()
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

defmodule TileMap do
  def line_up(map, tile, {coord, side}) do
    # map - reference tile, already placed
    # coord - coordinates for map tile to match, direction matters!
    # tile - tile to orient
    # side - side of tile that needs to match map
    border =
      case side do
        :north ->
          m = Map.get(map, coord)
          Enum.map(0..9, &Map.get(m, {9, &1}, "."))

        :south ->
          m = Map.get(map, coord)
          Enum.map(0..9, &Map.get(m, {0, &1}, "."))

        :west ->
          m = Map.get(map, coord)
          Enum.map(0..9, &Map.get(m, {&1, 9}, "."))

        :east ->
          m = Map.get(map, coord)
          Enum.map(0..9, &Map.get(m, {&1, 0}, "."))
      end

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
              tile

            # north matches, but needs to be south
            {0, :south} ->
              Tile.flip(tile, :horizontal)

            # north matches, but needs to be west
            {0, :west} ->
              # rotate and flip across vertical
              Tile.rotate(tile) |> Tile.flip(:vertical)

            # north matches, but needs to be east
            {0, :east} ->
              Tile.rotate(tile)

            # south matches, but needs to be north
            {1, :north} ->
              # flip across horizontal
              Tile.flip(tile, :horizontal)

            # south matches south
            {1, :south} ->
              tile

            # south matches, but needs to be west
            {1, :west} ->
              # rotate once
              Tile.rotate(tile)

            # south matches, but needs to be east
            {1, :east} ->
              # rotate once
              Tile.rotate(tile) |> Tile.flip(:vertical)

            # west matches, but needs to be north
            {2, :north} ->
              # rotate and flip across vertical
              Tile.rotate(tile) |> Tile.flip(:vertical)

            # west matches, but needs to be south
            {2, :south} ->
              # rotate and flip across vertical
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # west & west, no changes
            {2, :west} ->
              tile

            # west matches, but needs to be east
            {2, :east} ->
              Tile.flip(tile, :vertical)

            # east matches, but needs to be north
            {3, :north} ->
              # rotate three times!
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # east matches, but needs to be south
            {3, :south} ->
              # rotate three times!
              tile |> Tile.rotate() |> Tile.flip(:vertical)

            # east matches, but needs to be west
            {3, :west} ->
              Tile.flip(tile, :vertical)

            # east matches east
            {3, :east} ->
              tile

            # north reverse needs to match north
            {4, :north} ->
              Tile.flip(tile, :vertical)

            # north reverse needs to match south
            {4, :south} ->
              Tile.flip(tile, :vertical) |> Tile.flip(:horizontal)

            # north reverse needs to match west
            {4, :west} ->
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # north reverse needs to match east
            {4, :east} ->
              tile |> Tile.rotate() |> Tile.flip(:horizontal)

            # south reverse needs to match north
            {5, :north} ->
              Tile.flip(tile, :horizontal) |> Tile.flip(:vertical)

            # south reverse needs to match south
            {5, :south} ->
              Tile.flip(tile, :vertical)

            # south reverse needs to match west
            {5, :west} ->
              tile |> Tile.rotate() |> Tile.flip(:horizontal)

            # south reverse needs to match east
            {5, :east} ->
              tile |> Tile.rotate() |> Tile.rotate() |> Tile.rotate()

            # west reverse needs to match north
            {6, :north} ->
              tile |> Tile.rotate()

            # west reverse needs to match south
            {6, :south} ->
              tile |> Tile.rotate() |> Tile.flip(:horizontal)

            # west reverse needs to match west
            {6, :west} ->
              Tile.flip(tile, :horizontal)

            # west reverse needs to match east
            {6, :east} ->
              Tile.flip(tile, :horizontal) |> Tile.flip(:vertical)

            # east reverse
            {7, :north} ->
              Tile.flip(tile, :vertical) |> Tile.rotate()

            # east reverse
            {7, :south} ->
              Tile.rotate(tile)

            # east reverse
            {7, :west} ->
              Tile.flip(tile, :horizontal) |> Tile.flip(:vertical)

            # east reverse
            {7, :east} ->
              Tile.flip(tile, :horizontal)

            # no match means we hit an edge
            X ->
              IO.puts("Oh no you messed up!")
              {:fail, map, []}
          end

        # add tile to map and track new borders
        {r, c} = coord

        {map, new_borders} =
          case side do
            :north ->
              {Map.put(map, {r + 1, c}, tile),
               [
                 {{r + 1, c}, :north},
                 {{r + 1, c}, :west},
                 {{r + 1, c}, :east}
               ]}

            :south ->
              {Map.put(map, {r - 1, c}, tile),
               [
                 {{r - 1, c}, :south},
                 {{r - 1, c}, :west},
                 {{r - 1, c}, :east}
               ]}

            :west ->
              {Map.put(map, {r, c + 1}, tile),
               [
                 {{r, c + 1}, :north},
                 {{r, c + 1}, :south},
                 {{r, c + 1}, :west}
               ]}

            :east ->
              {Map.put(map, {r, c - 1}, tile),
               [
                 {{r, c - 1}, :north},
                 {{r, c - 1}, :south},
                 {{r, c - 1}, :east}
               ]}
          end

        {:hit, map, new_borders}
    end
  end

  def loop(map, [t | tiles], borders) do
    # map and borders should be initialized
    # for each tile, try to fit in one of the borders
    # on hit, drop tile and border
    case loop_borders(map, t, borders) do
      {:hit, map, new, old} ->
        # IO.puts("We fit this tile:")
        # Tile.print(t)
        # IO.puts("Removing this border:")
        # IO.inspect(old)
        # IO.puts("Adding these borders:")
        # IO.inspect(new)
        # TileMap.print(map)
        borders = List.delete(borders, old)
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

  defp loop_borders(_map, _, []) do
    {:miss}
  end

  def print(map) do
    {r_min, r_max} =
      Map.keys(map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()

    Enum.map(r_min..r_max, fn r -> print_row(map,r) end)
  end

  defp print_row(map, mr) do
    {c_min, c_max} =
      Map.keys(map) |> Enum.map(fn {_, c} -> c end) |> Enum.min_max()

    Enum.map(0..9, fn tr ->
      Enum.map(c_min..c_max, fn c ->
        tile = Map.get(map, {mr,c}, %{})
        Enum.map(0..9, &Map.get(tile, {tr, &1}, "."))
        |> Enum.reduce(&(&2 <> &1))
      end)
      |> Enum.join(" ")
      |> IO.puts()
    end)
    IO.puts("")
  end
end

defmodule SeaMap do
  def assemble(tile_map) do
    {r_min, r_max} =
      Map.keys(tile_map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()
    {c_min, c_max} =
      Map.keys(tile_map) |> Enum.map(fn {_, c} -> c end) |> Enum.min_max()
    Enum.flat_map(r_min..r_max, fn tr ->
      Enum.flat_map(c_min..c_max, fn tc ->
        # remove borders from tile, add to map
        Map.get(tile_map, {tr, tc})
        |> Enum.filter(fn {{r,c},_} -> (r<9) and (r>0) and (c<9) and (c>0) end)
        |> Enum.map(fn {{r,c}, v} -> {{((tr-r_min)*8)+r-1,((tc-c_min)*8)+c-1}, v} end)
      end)
    end)
    |> Enum.into(%{})
  end

  def print(sea_map) do
    {r_min, r_max} =
      Map.keys(sea_map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()
    {c_min, c_max} =
      Map.keys(sea_map) |> Enum.map(fn {_, c} -> c end) |> Enum.min_max()
    Enum.map(r_min..r_max, fn r ->
      Enum.map(c_min..c_max, &Map.get(sea_map, {r, &1}, "."))
      |> Enum.reduce(&(&2 <> &1))
      |> IO.puts()
    end)
  end

  def rotate(sea_map) do
    # rotate 90 degrees clockwise at a time
    # col 3 -> row 3
    # row 1 -> col 8
    {r_min, r_max} =
      Map.keys(sea_map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()
    flip = Enum.zip(r_min..r_max, r_max..r_min) |> Enum.into(%{})

    Map.keys(sea_map)
    |> Enum.map(fn {r, c} -> {{c, flip[r]}, "#"} end)
    |> Enum.into(%{})
  end

  def flip(sea_map, dir) do
    {r_min, r_max} =
      Map.keys(sea_map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()
    flip = Enum.zip(r_min..r_max, r_max..r_min) |> Enum.into(%{})
    case dir do
      :horizontal ->
        Map.keys(sea_map)
        |> Enum.map(fn {r, c} -> {{flip[r], c}, "#"} end)
        |> Enum.into(%{})

      :vertical ->
        Map.keys(sea_map)
        |> Enum.map(fn {r, c} -> {{r, flip[c]}, "#"} end)
        |> Enum.into(%{})
    end
  end

  def find_serpents(sea_map) do
    serpent = %{
      {0,18} => "#",
      {1,0} => "#",
      {1,5} => "#",
      {1,6} => "#",
      {1,11} => "#",
      {1,12} => "#",
      {1,17} => "#",
      {1,18} => "#",
      {1,19} => "#",
      {2,1} => "#",
      {2,4} => "#",
      {2,7} => "#",
      {2,10} => "#",
      {2,13} => "#",
      {2,16} => "#",
    }
    {r_min, r_max} =
      Map.keys(sea_map) |> Enum.map(fn {r, _} -> r end) |> Enum.min_max()
    {c_min, c_max} =
      Map.keys(sea_map) |> Enum.map(fn {_, c} -> c end) |> Enum.min_max()

    Enum.flat_map(r_min..r_max, fn r ->
      Enum.filter(c_min..c_max, fn c ->
        Enum.all?(serpent, fn {{ro, co}, v} -> Map.get(sea_map, {r+ro, c+co}) == v end)
      end)
      |> Enum.map(&({r,&1}))
    end)
  end

  def remove_serpents(sea_map) do
    serpent = %{
      {0,18} => "#",
      {1,0} => "#",
      {1,5} => "#",
      {1,6} => "#",
      {1,11} => "#",
      {1,12} => "#",
      {1,17} => "#",
      {1,18} => "#",
      {1,19} => "#",
      {2,1} => "#",
      {2,4} => "#",
      {2,7} => "#",
      {2,10} => "#",
      {2,13} => "#",
      {2,16} => "#",
    }
    coords = find_serpents(sea_map)
    # remove serpents from sea_map for each coords
    Enum.reduce(coords, sea_map, fn {r,c}, sm ->
      Enum.reduce(Map.keys(serpent), sm, fn {ro,co}, m ->
        Map.delete(m, {r+ro, c+co})
      end)
    end)
  end
end
