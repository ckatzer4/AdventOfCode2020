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

        String.contains?(rule, "|") ->
          # rule for an either or pattern
          [left, right] = String.split(rule, " | ")

          left =
            String.split(left)
            |> Enum.map(&String.to_integer/1)

          right =
            String.split(right)
            |> Enum.map(&String.to_integer/1)

          {:either, left, right}

        true ->
          # rule for a series of rules
          rule =
            String.split(rule)
            |> Enum.map(&String.to_integer/1)

          {:series, rule}
      end

    {String.to_integer(idx), rule}
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
end

defmodule Rules do
  def valid?(rules, message) do
    gr =
      graph(rules, 0)
    message in options(gr, [""], message)
  end

  def graph(rules, idx) do
    case rules[idx] do
      {:char, g} ->
        g

      {:series, s} ->
        Enum.map(s, &graph(rules, &1))

      {:either, l, r} ->
        {Enum.map(l, &graph(rules, &1)), Enum.map(r, &graph(rules, &1))}
    end
  end

  def options(chunks, opts \\ [""], test \\ nil)

  def options({left, right}, opts, _test) do
    # IO.puts("Left/right:")
    # IO.inspect({left, right})
    # IO.puts("#{length(opts)}")
    options(left, opts) ++ options(right, opts)
  end

  def options(series, opts, test) when is_list(series) do
    # IO.puts("Series:")
    # IO.inspect(series)
    # IO.puts("#{length(opts)}")
    # evaluate each individual chunk, then concat all combos
    Enum.reduce(series, opts, fn g, opts ->
      List.flatten(options(g, opts))
      # if we have a test case, attempt to filter
      |> Enum.filter(fn o ->
        case test do
          nil -> true
          _ -> String.starts_with?(test, o)
        end
      end)
    end)
  end

  def options(g, opts, _test) when is_binary(g) do
    # IO.puts("Binary: #{g}")
    for o <- opts, do: o<>g
  end
end
