defmodule Aoc12 do
  @moduledoc """
  Documentation for `Aoc12`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc12.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Stream.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      {ins, val} = String.split_at(s, 1)
      {String.to_atom(ins), String.to_integer(val)}
    end)
  end

  def part1(ins) do
    {east, north} = Boat.navigate(ins)
    abs(east) + abs(north)
  end

  def part2(ins) do
    {east, north} = Boat.nav_waypoint(ins)
    abs(east) + abs(north)
  end
end

defmodule Boat do
  # facing is determined by degrees
  # 0 is east, 90 is north, 180 is west, 270 is south
  def rotate(facing, turn, deg) do
    case turn do
      :L -> rem(facing + deg, 360)
      :R -> rem(facing - deg + 3600, 360)
    end
  end

  def rot_wp({wpe, wpn}, turn, deg) do
    case turn do
      :R ->
        sin = round(:math.sin(deg / 180 * :math.pi()))
        cos = round(:math.cos(deg / 180 * :math.pi()))
        {wpe * cos + wpn * sin, -wpe * sin + wpn * cos}

      :L ->
        sin = round(:math.sin(-deg / 180 * :math.pi()))
        cos = round(:math.cos(-deg / 180 * :math.pi()))
        {wpe * cos + wpn * sin, -wpe * sin + wpn * cos}
    end
  end

  def forward({east, north}, facing, val) do
    case facing do
      0 -> {east + val, north}
      90 -> {east, north + val}
      180 -> {east - val, north}
      270 -> {east, north - val}
    end
  end

  def navigate(directions, pos \\ {0, 0}, facing \\ 0)

  def navigate([], pos, _facing) do
    pos
  end

  def navigate([h | directions], {east, north}, facing) do
    case h do
      {:N, val} -> navigate(directions, {east, north + val}, facing)
      {:S, val} -> navigate(directions, {east, north - val}, facing)
      {:E, val} -> navigate(directions, {east + val, north}, facing)
      {:W, val} -> navigate(directions, {east - val, north}, facing)
      {:L, val} -> navigate(directions, {east, north}, rotate(facing, :L, val))
      {:R, val} -> navigate(directions, {east, north}, rotate(facing, :R, val))
      {:F, val} -> navigate(directions, forward({east, north}, facing, val), facing)
    end
  end

  def nav_waypoint(directions, boat \\ {0, 0}, wp \\ {10, 1}, facing \\ 0)

  def nav_waypoint([], boat, _wp, _facing) do
    boat
  end

  def nav_waypoint([h | directions], {east, north}, {wpe, wpn}, facing) do
    case h do
      {:N, val} ->
        nav_waypoint(directions, {east, north}, {wpe, wpn + val}, facing)

      {:S, val} ->
        nav_waypoint(directions, {east, north}, {wpe, wpn - val}, facing)

      {:E, val} ->
        nav_waypoint(directions, {east, north}, {wpe + val, wpn}, facing)

      {:W, val} ->
        nav_waypoint(directions, {east, north}, {wpe - val, wpn}, facing)

      {:L, val} ->
        nav_waypoint(directions, {east, north}, rot_wp({wpe, wpn}, :L, val), facing)

      {:R, val} ->
        nav_waypoint(directions, {east, north}, rot_wp({wpe, wpn}, :R, val), facing)

      {:F, val} ->
        nav_waypoint(directions, {east + val * wpe, north + val * wpn}, {wpe, wpn}, facing)
    end
  end
end
