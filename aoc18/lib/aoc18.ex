defmodule Aoc18 do
  @moduledoc """
  Documentation for `Aoc18`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc18.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n")
    |> Enum.filter(&(String.length(&1) > 0))
  end

  def part1(lines) do
    Stream.map(lines, &LineMath.solve(&1))
    |> Enum.sum()
  end

  def part2(lines) do
    Stream.map(lines, &LineMath.reduce/1)
    |> Stream.map(&AddFirstMath.ast/1)
    |> Stream.map(&AddFirstMath.solve/1)
    |> Enum.sum()
  end
end

defmodule LineMath do
  def reduce(line, res \\ [])
  # make a list of ints, ops, and [nested lines]
  # e.g. 1 + (2 * 3) + (4 * (5 + 6))
  # becomes [1,"+",[2,"*",3],"+",[4,"*",[5,"+",6]]

  def reduce("", res) do
    Enum.reverse(res)
  end

  def reduce(line, res) do
    case Regex.run(~r/\(.*\)/, line, return: :index) do
      [{0, _}] ->
        # starts with a nested expression
        len = find_group_end(line)
        group = reduce(String.slice(line, 1, len - 1))
        reduce(String.slice(line, len + 1, 500), [group | res])

      _ ->
        # no nested expression at top
        # add first element to res
        op = String.slice(line, 0, 1)
        reduce(String.slice(line, 2, 500), [op | res])
    end
  end

  def find_group_end(line) do
    {level, idx} =
      String.graphemes(line)
      |> Enum.drop(1)
      |> Enum.reduce({1, 1}, fn g, {level, idx} ->
        if level == 0 do
          # already found terminator
          {level, idx}
        else
          level =
            case g do
              "(" -> level + 1
              ")" -> level - 1
              _ -> level
            end

          {level, idx + 1}
        end
      end)

    idx + level
  end

  def solve([], res) do
    res
  end

  def solve([op, num | line], res) do
    op =
      case op do
        "+" -> &Kernel.+/2
        "*" -> &Kernel.*/2
      end

    case num do
      [h | t] ->
        case h do
          # starting with a double grouping 
          [i | u] ->
            i = String.to_integer(i)
            num = solve(t, solve(u, i))
            solve(line, op.(res, num))

          # starting with a single grouping 
          _ ->
            h = String.to_integer(h)
            num = solve(t, h)
            solve(line, op.(res, num))
        end

      _ ->
        num = String.to_integer(num)
        solve(line, op.(res, num))
    end
  end

  def solve(line) do
    line = reduce(line)

    init =
      case hd(line) do
        [h | t] ->
          case h do
            # starting with a double grouping 
            [i | u] ->
              i = String.to_integer(i)
              solve(t, solve(u, i))

            # starting with a single grouping 
            _ ->
              h = String.to_integer(h)
              solve(t, h)
          end

        i ->
          String.to_integer(i)
      end

    solve(tl(line), init)
  end
end

defmodule AddFirstMath do
  @doc """
  Parse our tokens into an execution tree.

  ## Examples

      iex> AddFirstMath.ast(["1", "+", "2"])
      {"+", [1, 2]}
      iex> AddFirstMath.ast(["1", "*", "2"])
      {"*", [1, 2]}
      iex> AddFirstMath.ast(["1", "+", "2", "*", "3"]) # 1 + 3 * 3
      {"*", [{"+", [1, 2]}, 3]}
      iex> AddFirstMath.ast(["1", "+", ["2", "*", "3"]]) # 1 + (2 * 3)
      {"+", [1, {"*", [2, 3]}]}
  """
  def ast(tokens)

  def ast([tree1, "+", tree2]) do
    # IO.puts("Got [tree1, \"+\", tree2]: [#{tree1}, \"+\", #{tree2}]")
    {"+", [ast(tree1), ast(tree2)]}
  end

  def ast([tree1, "*", tree2]) do
    # IO.puts("Got [tree1, \"*\", tree2]: [#{tree1}, \"*\", #{tree2}]")
    {"*", [ast(tree1), ast(tree2)]}
  end

  def ast([num]) when is_binary(num) do
    # IO.puts("Got [num]: #{num}")
    String.to_integer(num)
  end

  def ast(num) when is_binary(num) do
    # IO.puts("Got num: #{num}")
    String.to_integer(num)
  end

  def ast([tokens]) when is_list(tokens) do
    ast(tokens)
  end

  def ast(tokens) do
    # IO.inspect(tokens)
    mul_idx = Enum.find_index(tokens, &(&1 == "*"))

    case mul_idx do
      nil ->
        # no multiplication
        left = Enum.at(tokens, 0)
        right = Enum.drop(tokens, 2)
        # IO.puts("Splitting by add: [#{left}, #{right}]")
        {"+", [ast(left), ast(right)]}

      i ->
        # has multiplication, put it on the outside
        {left, [_ | right]} = Enum.split(tokens, i)
        # IO.puts("Splitting by mul: [#{left}, #{right}]")
        {"*", [ast(left), ast(right)]}
    end
  end

  def solve(ast) do
    case ast do
      {"+", [tree1, tree2]} -> solve(tree1) + solve(tree2)
      {"*", [tree1, tree2]} -> solve(tree1) * solve(tree2)
      n -> n
    end
  end
end
