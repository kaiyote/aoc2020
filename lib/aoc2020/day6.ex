defmodule Aoc2020.Day6 do
  @moduledoc false

  @doc ~S"""
    ## Examples

      iex> part1("abc
      ...>
      ...> a
      ...> b
      ...> c
      ...>
      ...> ab
      ...> ac
      ...>
      ...> a
      ...> a
      ...> a
      ...> a
      ...>
      ...> b")
      11

      iex> Aoc2020.load_data(6) |> part1()
      6775
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(fn s ->
      s
      |> String.replace(~r/\s/, "")
      |> String.split("", trim: true)
      |> Enum.uniq()
      |> length()
    end)
    |> Enum.reduce(fn len, acc -> len + acc end)
  end

  @doc ~S"""
    ## Examples

      iex> part2("abc
      ...>
      ...> a
      ...> b
      ...> c
      ...>
      ...> ab
      ...> ac
      ...>
      ...> a
      ...> a
      ...> a
      ...> a
      ...>
      ...> b")
      6

      iex> Aoc2020.load_data(6) |> part2()
      3356
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.map(fn group ->
      group
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(fn person -> person |> String.split("", trim: true) end)
      |> Enum.reduce(&filter_group/2)
    end)
    |> Enum.map(fn g -> g |> Enum.uniq() |> length() end)
    |> Enum.reduce(fn a, acc -> a + acc end)
  end

  @spec prepare_input(String.t()) :: [String.t()]
  defp prepare_input(input) do
    input
    |> String.split(~r/\n\n/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp filter_group(person, group_answers) do
    Enum.filter(group_answers, fn a -> Enum.member?(person, a) end)
  end
end
