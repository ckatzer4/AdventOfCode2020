defmodule Aoc22 do
  @moduledoc """
  Documentation for `Aoc22`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc22.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    [p1, p2] = String.split(text, "\n\n")

    p1 =
      String.split(p1, "\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.into(Deque.new())

    p2 =
      String.split(p2, "\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.into(Deque.new())

    {p1, p2}
  end

  def part1({p1, p2}) do
    Combat.find_winner(p1, p2)
    |> IO.inspect()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {v, i} -> (i + 1) * v end)
    |> Enum.sum()
  end

  def part2({p1, p2}) do
    case RecursiveCombat.find_winner(p1, p2) do
      {:p1, w1, _} -> w1
      {:p2, w2, _} -> w2
    end
    |> IO.inspect()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {v, i} -> (i + 1) * v end)
    |> Enum.sum() # not 33606
  end
end

defmodule Combat do
  def find_winner(p1, p2)

  def find_winner(p1, %Deque{list1: [], list2: []}) do
    p1
  end

  def find_winner(%Deque{list1: [], list2: []}, p2) do
    p2
  end

  def find_winner(p1, p2) do
    {c1, p1} = Deque.popleft(p1)
    {c2, p2} = Deque.popleft(p2)

    if c1 > c2 do
      p1 =
        Deque.append(p1, c1)
        |> Deque.append(c2)

      find_winner(p1, p2)
    else
      p2 =
        Deque.append(p2, c2)
        |> Deque.append(c1)

      find_winner(p1, p2)
    end
  end
end

defmodule RecursiveCombat do
  def find_winner(p1, p2, s \\ %MapSet{})

  def find_winner(p1, %Deque{list1: [], list2: []}, s) do
    {:p1, p1, s}
  end

  def find_winner(%Deque{list1: [], list2: []}, p2, s) do
    {:p2, p2, s}
  end

  def find_winner(p1, p2, s) do
    # IO.inspect({p1, p2})
    # IO.inspect(length(MapSet.to_list(s)))
    # check for infinite loop
    if MapSet.member?(s, {p1, p2}) do
      # instant p1 win
      {:p1, p1, s}
    else
      s = MapSet.put(s, {p1, p2})
      # draw
      {c1, p1} = Deque.popleft(p1)
      {c2, p2} = Deque.popleft(p2)

      # check lengths for sub-game
      if c1 <= p1.size and c2 <= p2.size do
        # recursive sub-game
        rp1 = Enum.take(p1, c1) |> Enum.into(Deque.new())

        rp2 = Enum.take(p2, c2) |> Enum.into(Deque.new())

        case find_winner(rp1, rp2) do
          {:p1, _, _} ->
            p1 =
              Deque.append(p1, c1)
              |> Deque.append(c2)

            find_winner(p1, p2, s)

          {:p2, _, _} ->
            p2 =
              Deque.append(p2, c2)
              |> Deque.append(c1)

            find_winner(p1, p2, s)
        end
      else
        # just play

        if c1 > c2 do
          p1 =
            Deque.append(p1, c1)
            |> Deque.append(c2)

          find_winner(p1, p2, s)
        else
          p2 =
            Deque.append(p2, c2)
            |> Deque.append(c1)

          find_winner(p1, p2, s)
        end
      end
    end
  end
end
