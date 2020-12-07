defmodule Aoc7Test do
  use ExUnit.Case
  doctest Aoc7

  test "greets the world" do
    assert Aoc7.hello() == :world
  end

  test "parse input" do
    text = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."

    assert Aoc7.parse(text) == %{
             "light red" => %{
               "bright white" => 1,
               "muted yellow" => 2
             },
             "dark orange" => %{
               "bright white" => 3,
               "muted yellow" => 4
             },
             "bright white" => %{
               "shiny gold" => 1
             },
             "dark olive" => %{
               "dotted black" => 4,
               "faded blue" => 3
             },
             "dotted black" => %{},
             "faded blue" => %{},
             "muted yellow" => %{
               "faded blue" => 9,
               "shiny gold" => 2
             },
             "shiny gold" => %{
               "dark olive" => 1,
               "vibrant plum" => 2
             },
             "vibrant plum" => %{
               "dotted black" => 6,
               "faded blue" => 5
             }
           }
  end

  test "will_contain?" do
    rules = %{
      "light red" => %{
        "bright white" => 1,
        "muted yellow" => 2
      },
      "dark orange" => %{
        "bright white" => 3,
        "muted yellow" => 4
      },
      "bright white" => %{
        "shiny gold" => 1
      },
      "dark olive" => %{
        "dotted black" => 4,
        "faded blue" => 3
      },
      "dotted black" => %{},
      "faded blue" => %{},
      "muted yellow" => %{
        "faded blue" => 9,
        "shiny gold" => 2
      },
      "shiny gold" => %{
        "dark olive" => 1,
        "vibrant plum" => 2
      },
      "vibrant plum" => %{
        "dotted black" => 6,
        "faded blue" => 5
      }
    }

    assert !BagRules.will_contain?(rules, "dotted black", "shiny gold")
    assert BagRules.will_contain?(rules, "muted yellow", "shiny gold")
    assert BagRules.will_contain?(rules, "dark orange", "shiny gold")
  end

  test "part1" do
    text = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."
    rules = Aoc7.parse(text)
    assert Aoc7.part1(rules) == 4
  end

  test "part2" do
    text1 = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."
    rules1 = Aoc7.parse(text1)
    assert BagRules.count_contents(rules1, "dark olive") == 7
    assert BagRules.count_contents(rules1, "vibrant plum") == 11
    assert Aoc7.part2(rules1) == 32
    text2 = "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."
    rules2 = Aoc7.parse(text2)
    assert Aoc7.part2(rules2) == 126
  end
end
