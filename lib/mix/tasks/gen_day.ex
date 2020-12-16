defmodule Mix.Tasks.GenDay do
  @moduledoc false
  use Mix.Task

  def run([day_num]) do
    app_dir = File.cwd!()
    app_name = Path.basename(app_dir)
    file_name = "day#{day_num}"
    code_path = Path.join([app_dir, "lib", app_name, "#{file_name}.ex"])
    test_path = Path.join([app_dir, "test", app_name, "#{file_name}_test.exs"])
    data_path = Path.join([app_dir, "data", "#{file_name}.txt"])

    File.write(code_path,
    """
    defmodule #{String.capitalize(app_name)}.#{String.capitalize(file_name)} do
      @moduledoc false

      @doc false
      @spec part1(String.t()) :: integer()
      def part1(input) do

      end

      @doc false
      @spec part2(String.t()) :: integer()
      def part2(input) do

      end

      @spec prepare_input(String.t()) :: any()
      defp prepare_input(input) do

      end
    end
    """, [:write])

    File.write(test_path,
    """
    defmodule #{String.capitalize(app_name)}.#{String.capitalize(file_name)}Test do
      @moduledoc false
      use ExUnit.Case, async: true

      doctest #{String.capitalize(app_name)}.#{String.capitalize(file_name)}, import: true
    end
    """, [:write])

    File.write(data_path, "", [:write])
  end
end
