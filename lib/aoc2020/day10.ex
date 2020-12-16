defmodule Aoc2020.Day10 do
  @moduledoc false

  @doc ~S"""
      iex> part1(sample1())
      7 * 5

      iex> part1(sample2())
      220

      iex> Aoc2020.load_data(10) |> part1()
      2030
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.reduce({0, []}, fn n, {prev, diffs} ->
      {n, diffs ++ [n - prev]}
    end)
    |> (fn {_, diffs} ->
      diffs
      |> Enum.group_by(fn n -> n end)
      |> (fn %{1 => ones, 3 => threes} -> length(ones) * (length(threes) + 1) end).()
    end).()
  end

  @doc ~S"""
      iex> part2(sample1())
      8

      iex> part2(sample2())
      19208

      iex> Aoc2020.load_data(10) |> part2()
      42313823813632
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> build_chains()
  end

  @spec prepare_input(String.t()) :: [integer()]
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
    |> Enum.sort()
  end

  @spec build_chains([integer()]) :: integer()
  defp build_chains(available_adapters) do
    [0 | available_adapters]
    |> Enum.reverse()
    |> Enum.reduce([], fn adapter, cache ->
      total_to_point = if adapter == Enum.max(available_adapters), do: 1, else: Enum.sum(for {a, c} <- cache, adapter < a, adapter >= a - 3, do: c)
      cache ++ [{adapter, total_to_point}]
    end)
    |> Enum.sort_by(fn {a, _} -> a end)
    |> Enum.at(0)
    |> elem(1)
  end

  @spec sample1 :: String.t()
  def sample1(), do: "16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4"

  def sample2(), do: "28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3"
end
