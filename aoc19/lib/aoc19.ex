defmodule Aoc19 do
  @moduledoc """
  Documentation for `Aoc19`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc19.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_rule(line) do
    [idx, rule] = String.split(line, ": ")

    rule =
      cond do
        String.contains?(rule, "\"") ->
          # rule for a specific character
          {:char, String.replace(rule, "\"", "")}

        true ->
          # rule is a nested list of options
          options =
            String.split(rule, " | ")
            |> Enum.map(&String.split(&1, " "))

          {:rule, options}
      end

    {idx, rule}
  end

  def parse(text) do
    [rules, messages] = String.split(text, "\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(&parse_rule/1)
      |> Enum.into(%{})

    messages =
      String.split(messages, "\n")
      |> Enum.filter(&(String.length(&1) > 0))

    {rules, messages}
  end

  def part1({rules, messages}) do
    Enum.count(messages, &Rules.valid?(rules, &1))
  end

  def part2({rules, messages}) do
    # clear cache since we have new rules
    Memoize.Cache.invalidate()
    # 8: 42 | 42 8
    # 11: 42 31 | 42 11 31
    rules = Map.put(rules, "8", {:rule, [["42"], ["42", "8"]]})
    rules = Map.put(rules, "11", {:rule, [["42", "31"], ["42", "11", "31"]]})
    Enum.count(messages, &Rules.valid?(rules, &1))
  end
end

defmodule Rules do
  use Memoize

  def valid?(rules, message) do
    check_message(rules, "0", message)
  end

  def check_message(rules, r, message) do
    # IO.inspect({r, message})
    Memoize.Cache.get_or_run({__MODULE__, :check, [r, message]}, fn ->
      # IO.inspect({"new", r, message})
      do_check_message(rules, r, message)
    end)
  end

  def do_check_message(rules, [r | rs], message) do
    1..String.length(message)
    |> Enum.map(&String.split_at(message, &1))
    |> Enum.any?(fn {head, tail} ->
      check_message(rules, r, head) and check_message(rules, rs, tail)
    end)
  end

  def do_check_message(_rules, [], ""), do: true
  def do_check_message(_rules, [], _), do: false
  def do_check_message(_rules, _r, ""), do: false

  def do_check_message(rules, idx, message) do
    case rules[idx] do
      {:char, g} ->
        g == message

      {:rule, s} ->
        Enum.any?(s, &check_message(rules, &1, message))
    end
  end
end
