defmodule Aoc25 do
  @moduledoc """
  Documentation for `Aoc25`.
  """

  def parse(text) do
    [door, card] = String.split(text, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    {door, card}
  end

  def part1({door_pub_key, card_pub_key}) do
    door_loop = Encryption.reverse_public_key(door_pub_key)
    Encryption.calc_encryption_key(card_pub_key, door_loop)
  end

  def part2({door_pub_key, card_pub_key}) do
    nil
  end
end

defmodule Encryption do
  def reverse_public_key(key, subj \\ 7, init \\ 1, loop \\ 0)

  def reverse_public_key(key, _subj, key, loop), do: loop

  def reverse_public_key(key, subj, init, loop) do
    next = rem(init*subj, 20201227)
    reverse_public_key(key, subj, next, loop+1)
  end

  def calc_encryption_key(pub, loop, init \\ 1)
  def calc_encryption_key(_pub, 0, key), do: key
  def calc_encryption_key(pub, loop, init) do
    next = rem(init*pub, 20201227)
    calc_encryption_key(pub, loop-1, next)
  end

end
