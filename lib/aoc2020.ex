defmodule Aoc2020 do
  @moduledoc false

  @spec load_data(integer()) :: binary
  def load_data(day) do
    "./data/day#{day}.txt"
    |> Path.relative_to_cwd()
    |> File.read!()
  end
end
