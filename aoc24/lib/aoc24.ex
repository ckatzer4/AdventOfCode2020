defmodule Aoc24 do
  @moduledoc """
  Documentation for `Aoc24`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc24.hello()
      :world

  """
  def hello do
    :world
  end

  def part1(dirs_list) do
    # {r,c} => true (black) | false (white, default)
    hex_tiles = HexTiles.build(dirs_list)
    Enum.count(hex_tiles)
  end

  def part2(dirs_list) do
    hex_tiles = HexTiles.build(dirs_list)
    hex_tiles = Enum.reduce(1..100, hex_tiles, fn _, ht ->
      HexTiles.next_day(ht)
    end)
    Enum.count(hex_tiles)
  end

  def parse(text) do
    String.split(text, "\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    {[], dirs} = String.graphemes(line)
    |> Enum.reduce({[],[]}, fn g, {in_prog, dirs} ->
      case {g, in_prog} do
        {"n", []} -> {["n"], dirs}
        {"s", []} -> {["s"], dirs}
        {"e", ["n"]} -> {[], [:ne | dirs]}
        {"e", ["s"]} -> {[], [:se | dirs]}
        {"e", []} -> {[], [:e | dirs]}
        {"w", ["n"]} -> {[], [:nw | dirs]}
        {"w", ["s"]} -> {[], [:sw | dirs]}
        {"w", []} -> {[], [:w | dirs]}
      end
    end)
    Enum.reverse(dirs)
  end
end

defmodule HexTiles do
  @moduledoc """
  Manipulating a HexTile Grid.

  HexTiles will be represented by their integer coordinates `{r, c}.
  The first row (r=) will be arranged flat-side to flat-side, west to east.
  The second row (and all odd rows), will be the tiles southeast of the HexTile with the same c coordinate of the row north.

   / \ / \ / \ / \
  |0,0|0,1|0,2|0,3|. . .
   \ / \ / \ / \ /
    |1,0|1,1|1,2|. . .
   / \ / \ / \ / \
  |2,0|2,1|2,2|2,3|. . .
   \ /.\ /.\ /.\ /
      .   .   .
      .   .   .  
  """

  @doc """
  Return the HexTile coordinates in a given direction.
  """
  def move({r,c}, direction) do
    case direction do
      :w -> {r,c-1}
      :e -> {r,c+1}
      :nw when rem(r,2) == 0 -> {r-1,c-1}
      :nw -> {r-1,c}
      :ne when rem(r,2) == 0 -> {r-1,c}
      :ne -> {r-1,c+1}
      :sw when rem(r,2) == 0 -> {r+1,c-1}
      :sw -> {r+1,c}
      :se when rem(r,2) == 0 -> {r+1,c}
      :se -> {r+1,c+1}
    end
  end

  def build(dirs_list) do
    Enum.reduce(dirs_list, %{}, fn dirs, hex_tiles ->
      {r,c} = Enum.reduce(dirs, {0,0}, fn d, hex ->
        HexTiles.move(hex, d)
      end)
      case Map.get(hex_tiles, {r,c}, false) do
        true -> Map.delete(hex_tiles, {r,c})
        false-> Map.put(hex_tiles, {r,c}, true)
      end
    end)
  end

  def neighbors(hex_tiles, coord) do
    [:nw, :ne, :w, :e, :sw, :se]
    |> Enum.map(fn d -> move(coord, d) end)
  end

  # of course its cellular automata!
  def next_day(hex_tiles) do
    white_neigh =
      Map.keys(hex_tiles)
      |> Enum.flat_map(&neighbors(hex_tiles, &1))
      |> Enum.filter(fn c -> !Map.get(hex_tiles, c, false) end)
    # Any white tile with exactly 2 black tiles 
    # immediately adjacent to it is flipped to black.
    born = Enum.filter(white_neigh, fn c ->
      count = Enum.count(neighbors(hex_tiles, c), fn n ->
        Map.get(hex_tiles, n, false)
      end)
      count == 2
    end)

    # Any black tile with zero or more than 2 black tiles 
    # immediately adjacent to it is flipped to white.
    survives = Map.keys(hex_tiles)
    |> Enum.filter(fn c ->
      count = Enum.count(neighbors(hex_tiles, c), fn n ->
        Map.get(hex_tiles, n, false)
      end)
      (count>0) and (count<3)
    end)

    Enum.concat(born, survives)
    |> Enum.map(&({&1, true}))
    |> Enum.into(%{})
  end
end
