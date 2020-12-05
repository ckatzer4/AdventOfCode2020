defmodule Aoc5Test do
  use ExUnit.Case
  doctest Aoc5

  test "greets the world" do
    assert Aoc5.hello() == :world
  end

  test "seat search" do
    # BFFFBBFRRR: row 70, column 7, seat ID 567.
    # FFFBBBFRRR: row 14, column 7, seat ID 119.
    # BBFFBBFRLL: row 102, column 4, seat ID 820.

    assert Seat.search("BFFFBBFRRR") == {:ok, 70, 7}
    assert Seat.search("FFFBBBFRRR") == {:ok, 14, 7}
    assert Seat.search("BBFFBBFRLL") == {:ok, 102, 4}
  end
end
