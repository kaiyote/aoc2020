defmodule Aoc2020.Day7 do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :bag, String.t(), enforce: true
    field :contains, [{integer(), String.t()}], default: []
  end

  @doc ~S"""
      iex> part1("light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...>        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...>        bright white bags contain 1 shiny gold bag.
      ...>        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...>        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...>        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...>        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...>        faded blue bags contain no other bags.
      ...>        dotted black bags contain no other bags.", "shiny gold")
      4

      iex> Aoc2020.load_data(7) |> part1("shiny gold")
      208
  """
  @spec part1(String.t(), String.t()) :: integer()
  def part1(input, base_bag) do
    bags = input
    |> parse_input()
    |> Enum.filter(fn %{bag: bag} -> bag != base_bag end)

    bags
    |> Enum.filter(fn bag -> bag_contains?(bags, bag, base_bag) end)
    |> length()
  end

  @doc ~S"""
      iex> part2("shiny gold bags contain 2 dark red bags.
      ...> dark red bags contain 2 dark orange bags.
      ...> dark orange bags contain 2 dark yellow bags.
      ...> dark yellow bags contain 2 dark green bags.
      ...> dark green bags contain 2 dark blue bags.
      ...> dark blue bags contain 2 dark violet bags.
      ...> dark violet bags contain no other bags.", "shiny gold")
      126

      iex> Aoc2020.load_data(7) |> part2("shiny gold")
      1664
  """
  @spec part2(String.t(), String.t()) :: integer()
  def part2(input, base_bag) do
    input
    |> parse_input()
    |> number_of_bags(base_bag)
    |> Kernel.-(1)
  end

  @spec parse_input(String.t()) :: [t()]
  defp parse_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&bag_rule/1)
  end

  @spec bag_rule(String.t()) :: t()
  defp bag_rule(rule) do
    [color, contains] = String.split(rule, " bags contain ", trim: true, parts: 2)
    %__MODULE__{
      bag: color,
      contains: contains_section(contains)
    }
  end

  @spec contains_section(String.t()) :: [{integer(), String.t()}]
  defp contains_section(input) do
    input
    |> String.replace(".", "")
    |> String.split(",", trim: true)
    |> Enum.map(fn s -> s |> String.split(" ", trim: true) end)
    |> Enum.map(fn
      [num, colora, colorb, _bags] -> {Integer.parse(num) |> elem(0), colora <> " " <> colorb}
      ["no" | _] -> nil
    end)
    |> Enum.reject(fn c -> c == nil end)
  end

  @spec bag_contains?([t()], t(), String.t()) :: boolean()
  defp bag_contains?(bags, search_bag, find_bag) do
    Enum.any?(search_bag.contains, fn {_, color} -> color == find_bag end) or
    Enum.any?(search_bag.contains, fn {_, color} ->
      new_bag = Enum.find(bags, fn %{bag: bag} -> bag == color end)
      bag_contains?(bags, new_bag, find_bag)
    end)
  end

  @spec number_of_bags([t()], String.t()) :: integer()
  defp number_of_bags(bags, search_bag) do
    bags
    |> Enum.find(fn %{bag: bag} -> bag == search_bag end)
    |> Map.get(:contains)
    |> Enum.map(fn {count, color} -> count * number_of_bags(bags, color) end)
    |> Enum.reduce(1, fn b, tot -> b + tot end)
  end
end
