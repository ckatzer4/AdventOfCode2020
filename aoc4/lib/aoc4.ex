defmodule Aoc4 do
  @moduledoc """
  Documentation for `Aoc4`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc4.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    String.split(text, "\n\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn l -> for s <- l, do: String.split(s, ":") end)
    |> Enum.map(fn l -> for [k, v] <- l, do: {String.to_atom(k), v} end)
    |> Enum.map(fn l -> Enum.into(l, %{}) end)
  end

  def part1(batches) do
    Enum.count(batches, &Batch.verify_keys/1)
  end

  def part2(batches) do
    Enum.count(batches, &Batch.verify/1)
  end
end

defmodule Batch do
  def verify_keys(%{cid: _cid} = batch) do
    {_cid, batch} = Map.pop!(batch, :cid)
    verify_keys(batch)
  end

  def verify_keys(batch) do
    needed = [
      # (Birth Year)
      :byr,
      # (Issue Year)
      :iyr,
      # (Expiration Year)
      :eyr,
      # (Height)
      :hgt,
      # (Hair Color)
      :hcl,
      # (Eye Color)
      :ecl,
      # (Passport ID)
      :pid
    ]

    Enum.all?(for a <- needed, do: Map.has_key?(batch, a))
  end

  def verify_byr(byr) do
    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    byr = String.to_integer(byr)
    byr >= 1920 and byr <= 2002
  end

  def verify_iyr(iyr) do
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    iyr = String.to_integer(iyr)
    iyr >= 2010 and iyr <= 2020
  end

  def verify_eyr(eyr) do
    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    eyr = String.to_integer(eyr)
    eyr >= 2020 and eyr <= 2030
  end

  def verify_hgt(hgt) do
    # hgt (Height) - a number followed by either cm or in:
    #   If cm, the number must be at least 150 and at most 193.
    #   If in, the number must be at least 59 and at most 76.
    cond do
      String.ends_with?(hgt, "cm") ->
        hgt = String.replace_suffix(hgt, "cm", "")
        hgt = String.to_integer(hgt)
        hgt >= 150 and hgt <= 193

      String.ends_with?(hgt, "in") ->
        hgt = String.replace_suffix(hgt, "in", "")
        hgt = String.to_integer(hgt)
        hgt >= 59 and hgt <= 76

      true ->
        false
    end
  end

  def verify_hcl(hcl) do
    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    String.match?(hcl, ~r/#[0-9a-f]{6}/)
  end

  def verify_ecl(ecl) do
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl)
  end

  def verify_pid(pid) do
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    if String.length(pid) == 9 do
      String.match?(pid, ~r/[0-9]{9}/)
    else
      false
    end
  end

  def verify(batch) do
    if !verify_keys(batch) do
      false
    else
      tests = [
        {:byr, &verify_byr/1},
        {:iyr, &verify_iyr/1},
        {:eyr, &verify_eyr/1},
        {:hgt, &verify_hgt/1},
        {:hcl, &verify_hcl/1},
        {:ecl, &verify_ecl/1},
        {:pid, &verify_pid/1}
      ]

      result = Enum.all?(tests, fn {k, test} -> test.(batch[k]) end)
      # IO.inspect(for {k, test} <- tests, do: {k, batch[k], test.(batch[k])} )
      result
    end
  end
end

{:ok, text} = File.read("input")
batches = Aoc4.parse(text)
IO.puts(Aoc4.part1(batches))
IO.puts(Aoc4.part2(batches))
