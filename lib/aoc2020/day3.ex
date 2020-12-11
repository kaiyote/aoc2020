defmodule Aoc2020.Day3 do
  use TypedStruct

  typedstruct do
    field :slope_x, integer(), enforce: true
    field :slope_y, integer(), enforce: true
    field :pos_x, integer(), default: 0
    field :pos_y, integer(), default: 0
    field :trees, integer(), default: 0
  end

  @moduledoc ~S"""
      iex> sample = "..##.......
      ...>          #...#...#..
      ...>          .#....#..#.
      ...>          ..#.#...#.#
      ...>          .#...##..#.
      ...>          ..#.##.....
      ...>          .#.#.#....#
      ...>          .#........#
      ...>          #.##...#...
      ...>          #...##....#
      ...>          .#..#...#.#"
      iex> traverse(sample, %Aoc2020.Day3{slope_x: 3, slope_y: 1})
      7
      iex> part2Slopes = [
      ...> %Aoc2020.Day3{slope_x: 1, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 3, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 5, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 7, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 1, slope_y: 2}
      ...> ]
      iex> part2Slopes
      ...> |> Enum.map(fn s -> traverse(sample, s) end)
      ...> |> Enum.reduce(fn elm, acc -> elm * acc end)
      336

      iex> data = Aoc2020.load_data(3)
      iex> traverse(data, %Aoc2020.Day3{slope_x: 3, slope_y: 1})
      162
      iex> part2Slopes = [
      ...> %Aoc2020.Day3{slope_x: 1, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 3, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 5, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 7, slope_y: 1},
      ...> %Aoc2020.Day3{slope_x: 1, slope_y: 2}
      ...> ]
      iex> part2Slopes
      ...> |> Enum.map(fn s -> traverse(data, s) end)
      ...> |> Enum.reduce(fn elm, acc -> elm * acc end)
      3064612320
  """

  @spec traverse(String.t(), t()) :: integer()
  def traverse(input, slope) do
    input
    |> prepare_input()
    |> Enum.take_every(slope.slope_y)
    |> Enum.reduce(slope, fn row, acc ->
      %{acc |
        trees: acc.trees + tree(row, acc.pos_x),
        pos_x: rem(acc.pos_x + acc.slope_x, String.length(row))
      }
    end)
    |> Map.get(:trees)
  end

  @spec prepare_input(String.t()) :: [String.t()]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp tree(row, index) do
    if String.at(row, index) == "#", do: 1, else: 0
  end
end
