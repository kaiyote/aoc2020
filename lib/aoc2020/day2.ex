defmodule Aoc2020.Day2 do
  @moduledoc false
  use Bitwise
  use TypedStruct

  typedstruct do
    field :counts, {integer(), integer()}, enforce: true
    field :char, String.t(), enforce: true
    field :pass, String.t(), enforce: true
  end

  @doc ~S"""
    ## Examples

      iex> part1("1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc")
      2

      iex> Aoc2020.load_data(2) |> part1()
      500
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.filter(fn r ->
      correct_length = String.length(r.pass) - (r.pass |> String.replace(r.char, "") |> String.length())
      range = Range.new(elem(r.counts, 0), elem(r.counts, 1))
      correct_length in range
    end)
    |> length
  end

  @doc ~S"""
    ## Examples

      iex> part2("1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc")
      1

      iex> Aoc2020.load_data(2) |> part2()
      313
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.filter(fn r ->
      left_side = bool_to_int(String.at(r.pass, elem(r.counts, 0) - 1) == r.char)
      right_side = bool_to_int(String.at(r.pass, elem(r.counts, 1) - 1) == r.char)
      int_to_bool(left_side ^^^ right_side)
    end)
    |> length
  end

  @spec prepare_input(String.t()) :: [t()]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/)
    |> Enum.map(fn l -> l |> String.trim() end)
    |> Enum.map(fn line ->
      [x, y, char, pass] = String.split(line, ~r/(-|:|\s)/, trim: true)
      %__MODULE__{
        counts: {
          x |> Integer.parse() |> elem(0),
          y |> Integer.parse() |> elem(0)
        },
        char: char,
        pass: pass
      }
    end)
  end

  defp bool_to_int(bool), do: if bool, do: 1, else: 0
  defp int_to_bool(int), do: if int == 0, do: false, else: true
end
