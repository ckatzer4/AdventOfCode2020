defmodule Aoc16 do
  @moduledoc """
  Documentation for `Aoc16`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc16.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_rule(line) do
    [_, field, low1, high1, low2, high2] =
      Regex.run(~r/([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/, line)

    to_i = &String.to_integer/1
    {field, {to_i.(low1), to_i.(high1), to_i.(low2), to_i.(high2)}}
  end

  def parse(text) do
    [rules, my_ticket, nearby] = String.split(text, "\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(&parse_rule/1)

    [_, my_ticket] = String.split(my_ticket, "\n")

    nearby =
      String.split(nearby, "\n")
      |> Enum.filter(fn s -> String.length(s) > 0 end)
      |> Enum.drop(1)

    {rules, my_ticket, nearby}
  end

  def part1({rules, _my_ticket, nearby}) do
    Enum.flat_map(nearby, &Ticket.invalid_fields(&1, rules))
    |> Enum.sum()
  end

  def part2({rules, mine, nearby}) do
    valid = Enum.filter(nearby, &Ticket.valid?(&1, rules))

    options =
      Enum.map(0..(length(String.split(mine, ",")) - 1), fn i ->
        {i, Ticket.valid_fields(valid, rules, i)}
      end)
      |> Enum.into(%{})

    field_map = resolve(options)

    Enum.filter(field_map, fn {field, _} -> String.contains?(field, "departure") end)
    |> Enum.map(fn {_f, idx} ->
      String.split(mine, ",")
      |> Enum.at(idx)
      |> String.to_integer()
    end)
    |> Enum.reduce(&(&1 * &2))
  end

  def resolve(original, result \\ %{}) do
    # take our mapping if idx => [potential fields]
    # to actual field => idx
    if length(Map.keys(original)) == length(Map.keys(result)) do
      result
    else
      # we can be certain about lists with one option in them
      isolated =
        Enum.filter(original, fn {_k, v} -> length(v) == 1 end)
        |> Enum.map(fn {k, [v]} -> {v, k} end)

      {original, result} =
        Enum.reduce(isolated, {original, result}, fn {field, idx}, {orig, res} ->
          # pop field out of all original values
          orig =
            Enum.map(orig, fn {i, vals} ->
              {i, List.delete(vals, field)}
            end)
            |> Enum.into(%{})

          # add field to result
          {orig, Map.put(res, field, idx)}
        end)

      resolve(original, result)
    end
  end
end

defmodule Ticket do
  def test_val?(val, {_field, {low1, high1, low2, high2}}) do
    (val >= low1 and val <= high1) or (val >= low2 and val <= high2)
  end

  def invalid_fields(ticket, rules) do
    String.split(ticket, ",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.filter(fn t -> !Enum.any?(rules, &test_val?(t, &1)) end)
  end

  def valid?(ticket, rules) do
    length(invalid_fields(ticket, rules)) == 0
  end

  def valid_fields(tickets, rules, index, valid \\ [])

  def valid_fields(_t, [], _i, valid) do
    valid
  end

  def valid_fields(tickets, [r | rules], i, valid) do
    # test rule for all fields at index i
    all_pass =
      Enum.all?(tickets, fn t ->
        val =
          String.split(t, ",")
          |> Enum.at(i)
          |> String.to_integer()

        test_val?(val, r)
      end)

    if all_pass do
      {f, _} = r
      valid_fields(tickets, rules, i, [f | valid])
    else
      valid_fields(tickets, rules, i, valid)
    end
  end
end
