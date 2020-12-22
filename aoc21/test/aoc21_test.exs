defmodule Aoc21Test do
  use ExUnit.Case
  doctest Aoc21

  test "parse" do
    text = "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"
    {ingredients, allergens} = Aoc21.parse(text)
    assert length(ingredients) == 4
    assert List.first(allergens) == ["dairy", "fish"]
    assert Aoc21.part1({ingredients, allergens}) == 5
    assert Aoc21.part2({ingredients, allergens}) == "mxmxvkd,sqjhc,fvjkl"
  end
end
