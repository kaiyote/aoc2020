defmodule Aoc2020.Day5 do
  @moduledoc false

  @doc ~S"""
    ## Examples

      iex> part1("FBFBBFFRLR
      ...>        BFFFBBFRRR
      ...>        FFFBBBFRRR
      ...>        BBFFBBFRLL")
      820

      iex> Aoc2020.load_data(5) |> part1()
      832
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(fn s -> s |> Integer.parse(2) |> elem(0) end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.at(0)
  end

  @doc ~S"""
    ## Examples

      iex> Aoc2020.load_data(5) |> part2()
      517
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.map(fn s -> s |> Integer.parse(2) |> elem(0) end)
    |> Enum.sort()
    |> Enum.reduce_while(0, fn i, prev ->
      case i - prev do
        2 -> {:halt, i - 1}
        1 -> {:cont, i}
        i -> {:cont, i}
      end
    end)
  end

  @spec prepare_input(String.t()) :: [String.t()]
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(fn s ->
      s
      |> String.trim()
      |> String.replace(~r/(F|L)/, "0")
      |> String.replace(~r/(B|R)/, "1")
    end)
  end
end
