defmodule Aoc2020.Day9 do
  @moduledoc false

  @doc ~S"""
      iex> part1("35
      ...> 20
      ...> 15
      ...> 25
      ...> 47
      ...> 40
      ...> 62
      ...> 55
      ...> 65
      ...> 95
      ...> 102
      ...> 117
      ...> 150
      ...> 182
      ...> 127
      ...> 219
      ...> 299
      ...> 277
      ...> 309
      ...> 576", 5)
      127

      iex> Aoc2020.load_data(9) |> part1(25)
      1721308972
  """
  @spec part1(String.t(), integer()) :: integer()
  def part1(input, preamble_size) do
    input
    |> prepare_input()
    |> Enum.chunk_every(preamble_size + 1, 1, :discard)
    |> Enum.drop_while(&is_valid_chunk?/1)
    |> Enum.at(0)
    |> Enum.reverse()
    |> Enum.at(0)
  end

  @doc ~S"""
      iex> part2("35
      ...> 20
      ...> 15
      ...> 25
      ...> 47
      ...> 40
      ...> 62
      ...> 55
      ...> 65
      ...> 95
      ...> 102
      ...> 117
      ...> 150
      ...> 182
      ...> 127
      ...> 219
      ...> 299
      ...> 277
      ...> 309
      ...> 576", 127)
      62

      iex> Aoc2020.load_data(9) |> part2(1721308972)
      209694133
  """
  @spec part2(String.t(), integer()) :: integer()
  def part2(input, number_to_find) do
    input
    |> prepare_input()
    |> find_contiguous_sum(number_to_find)
  end

  @spec prepare_input(String.t()) :: [integer()]
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
  end

  @spec is_valid_chunk?([integer()]) :: boolean()
  defp is_valid_chunk?(chunk) do
    under_test = chunk |> Enum.reverse() |> Enum.at(0)
    chunk
    |> Enum.reverse()
    |> Enum.drop(1)
    |> has_sum?(under_test)
  end

  @spec has_sum?([integer()], integer()) :: boolean()
  defp has_sum?([x | tail], sum_to_find) do
    if Enum.any?(tail, fn y -> x + y == sum_to_find end), do: true, else: has_sum?(tail, sum_to_find)
  end
  defp has_sum?(_, _), do: false

  @spec find_contiguous_sum([integer()], integer()) :: integer()
  defp find_contiguous_sum(nums, sum_to_find) do
    Stream.iterate(2, fn x -> x + 1 end)
    |> Stream.map(fn i -> contiguous_chunk_sum(i, nums, sum_to_find) end)
    |> Stream.drop_while(fn s -> s == :not_found end)
    |> Stream.take(1)
    |> Enum.at(0)
    |> elem(1)
    |> (fn {x, y} -> x + y end).()
  end

  @spec contiguous_chunk_sum(integer(), [integer()], integer()) :: {:found, {integer(), integer()}} | :not_found
  defp contiguous_chunk_sum(chunk_size, array, sum_to_find) do
    array
    |> Enum.chunk_every(chunk_size, 1, :discard)
    |> Enum.drop_while(fn chunk -> Enum.sum(chunk) != sum_to_find end)
    |> Enum.take(1)
    |> (fn
      [] -> :not_found
      [chunk] -> {:found, Enum.min_max(chunk)}
    end).()
  end
end
