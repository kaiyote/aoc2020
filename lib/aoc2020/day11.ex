defmodule Aoc2020.Day11 do
  @moduledoc false

  @doc ~S"""
      iex> part1(sample())
      37
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Stream.iterate(&game_of_chairs/1)
    |> Enum.reduce_while([], &same_field?/2)
    |> Enum.map(fn c -> c |> String.to_charlist() |> Enum.filter(fn c -> c == '#' end) |> length end)
    |> Enum.sum()
  end

  @doc false
  @spec part2(String.t()) :: integer()
  def part2(input) do

  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  @spec game_of_chairs([String.t()]) :: [String.t()]
  defp game_of_chairs(chairs) do
    chairs
  end

  defp same_field?(chairs, other_chairs) do
    if Enum.all?(chairs, fn c -> Enum.member?(other_chairs, c) end),
      do: {:halt, chairs},
      else: {:cont, chairs}
  end

  @spec sample() :: String.t()
  def sample(), do: "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"
end
