defmodule Aoc2020.Day8 do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :acc, integer(), default: 0
    field :instructions, [String.t()], enforce: true
    field :register, integer(), default: 0
    field :visited_instructions, [integer()], default: []
  end

  @doc ~S"""
      iex> part1("nop +0
      ...> acc +1
      ...> jmp +4
      ...> acc +3
      ...> jmp -3
      ...> acc -99
      ...> acc +1
      ...> jmp -4
      ...> acc +6")
      5

      iex> Aoc2020.load_data(8) |> part1()
      1600
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> process()
    |> elem(1)
  end

  @doc ~S"""
      iex> part2("nop +0
      ...> acc +1
      ...> jmp +4
      ...> acc +3
      ...> jmp -3
      ...> acc -99
      ...> acc +1
      ...> jmp -4
      ...> acc +6")
      8

      iex> Aoc2020.load_data(8) |> part2()
      1543
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    program = input
    |> prepare_input()

    0..(length(program) - 1)
    |> Enum.reduce_while(0, fn i, _ -> modify_prog_and_process(i, program) end)
  end

  @spec prepare_input(String.t()) :: [String.t()]
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  @spec modify_prog_and_process(integer(), [String.t()]) :: {:cont | :halt, integer()}
  defp modify_prog_and_process(index_to_modify, program) do
    if program |> Enum.at(index_to_modify) |> String.starts_with?(["jmp", "nop"]) do
      replaced_instruction = program |> Enum.at(index_to_modify) |> String.replace(~r/(jmp|nop)/, fn
        "jmp" -> "nop"
        "nop" -> "jmp"
      end)
      new_prog = Enum.take(program, index_to_modify) ++ [replaced_instruction] ++ Enum.drop(program, index_to_modify + 1)
      case process(new_prog) do
        {:loop, acc} -> {:cont, acc}
        {:finished, acc} -> {:halt, acc}
      end
    else
      {:cont, 0}
    end
  end

  @spec process([String.t()], integer(), integer(), [integer()]) :: {:loop | :finished, integer()}
  defp process(instructions, acc \\ 0, index \\ 0, seen_steps \\ []) do
    if index in seen_steps or index >= length(instructions) do
      {(if index >= length(instructions), do: :finished, else: :loop), acc}
    else
      steps = seen_steps ++ [index]
      case Enum.at(instructions, index) do
        "nop" <> _ -> process(instructions, acc, index + 1, steps)
        "acc " <> num -> process(instructions, acc + get_change(num), index + 1, steps)
        "jmp " <> num -> process(instructions, acc, index + get_change(num), steps)
      end
    end
  end

  @spec get_change(String.t()) :: integer()
  defp get_change(num) do
    num |> Integer.parse() |> elem(0)
  end
end
