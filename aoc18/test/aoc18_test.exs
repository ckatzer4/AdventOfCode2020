defmodule Aoc18Test do
  use ExUnit.Case
  doctest Aoc18
  doctest AddFirstMath

  test "greets the world" do
    assert Aoc18.hello() == :world
  end

  test "LineMath" do
    assert LineMath.solve("1 + 2 * 3 + 4 * 5 + 6") == 71
    assert LineMath.solve("1 + (2 * 3) + (4 * (5 + 6))") == 51
    uhoh = "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
    assert LineMath.solve(uhoh) == 13632
  end

  test "AddFirstMath" do
    ops = LineMath.reduce("1 + 2 * 3 + 4 * 5 + 6")

    assert AddFirstMath.ast(ops) ==
             {"*", [{"+", [1, 2]}, {"*", [{"+", [3, 4]}, {"+", [5, 6]}]}]}

    ops = LineMath.reduce("1 + (2 * 3) + (4 * (5 + 6))")

    assert AddFirstMath.ast(ops) ==
             {"+", [1, {"+", [{"*", [2, 3]}, {"*", [4, {"+", [5, 6]}]}]}]}

    ops = LineMath.reduce("1 + 2 * 3 + 4 * 5 + 6")
    ast = AddFirstMath.ast(ops)
    assert AddFirstMath.solve(ast) == 231

    test =
      LineMath.reduce("2 * 3 + (4 * 5)")
      |> AddFirstMath.ast()
      |> AddFirstMath.solve()

    assert test = 46

    test =
      LineMath.reduce("5 + (8 * 3 + 9 + 3 * 4 * 3)")
      |> AddFirstMath.ast()
      |> AddFirstMath.solve()

    assert test = 1445

    test =
      LineMath.reduce("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
      |> AddFirstMath.ast()
      |> AddFirstMath.solve()

    assert test = 669_060

    IO.puts("====")
    test =
      LineMath.reduce("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
      |> AddFirstMath.ast()
      |> AddFirstMath.solve()

    assert test = 23340
  end
end
