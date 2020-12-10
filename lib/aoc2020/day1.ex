defmodule Aoc2020.Day1 do
  @moduledoc false

  @doc ~S"""
    ## Examples

      iex> part1("1721
      ...>        979
      ...>        366
      ...>        299
      ...>        675
      ...>        1456")
      514579

      iex> "./data/day1.txt"
      ...> |> Path.relative_to_cwd()
      ...> |> File.read!()
      ...> |> part1()
      211899
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
      input
      |> prepare_input()
      |> finder()
  end

  @doc ~S"""
    ## Examples

      iex> part2("1721
      ...>        979
      ...>        366
      ...>        299
      ...>        675
      ...>        1456")
      241861950

      iex> "./data/day1.txt"
      ...> |> Path.relative_to_cwd()
      ...> |> File.read!()
      ...> |> part2()
      275765682
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> finder_3()
  end

  @spec prepare_input(String.t()) :: [integer()]
  defp prepare_input(input) do
    input
      |> String.trim()
      |> String.split(~r/\n/)
      |> Enum.map(&(&1 |> String.trim() |> Integer.parse() |> elem(0)))
  end

  @spec finder([integer()]) :: integer()
  defp finder(list) do
    case list do
      [x | xs] -> Enum.at((for y <- xs, y + x == 2020, do: y * x), 0) || finder(xs)
      _ -> nil
    end
  end

  @spec finder_3([integer()]) :: integer()
  defp finder_3(list) do
    for x <- list do
      for y <- list, y != x, x + y < 2020 do
        for z <- list, z != y, x + y + z == 2020, do: x * y * z
      end
    end
    |> Enum.flat_map(&(Enum.flat_map(&1, fn x -> x end)))
    |> Enum.at(0)
  end
end
