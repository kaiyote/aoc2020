defmodule Aoc2020.Day4 do
  @moduledoc false
  use TypedStruct

  typedstruct do
    field :byr, String.t(), default: ""
    field :iyr, String.t(), default: ""
    field :eyr, String.t(), default: ""
    field :hgt, String.t(), default: ""
    field :hcl, String.t(), default: ""
    field :ecl, String.t(), default: ""
    field :pid, String.t(), default: ""
    field :cid, String.t(), default: ""
  end

  @doc ~S"""
      iex> sample = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      ...> byr:1937 iyr:2017 cid:147 hgt:183cm
      ...>
      ...> iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      ...> hcl:#cfa07d byr:1929
      ...>
      ...> hcl:#ae17e1 iyr:2013
      ...> eyr:2024
      ...> ecl:brn pid:760753108 byr:1931
      ...> hgt:179cm
      ...>
      ...> hcl:#cfa07d eyr:2025 pid:166559648
      ...> iyr:2011 ecl:brn hgt:59in"
      iex> part1(sample)
      2

      iex> Aoc2020.load_data(4) |> part1()
      235
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.filter(&has_values/1)
    |> length()
  end

  @doc ~S"""
      iex> sample = "eyr:1972 cid:100
      ...> hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
      ...>
      ...> iyr:2019
      ...> hcl:#602927 eyr:1967 hgt:170cm
      ...> ecl:grn pid:012533040 byr:1946
      ...>
      ...> hcl:dab227 iyr:2012
      ...> ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
      ...>
      ...> hgt:59cm ecl:zzz
      ...> eyr:2038 hcl:74454a iyr:2023
      ...> pid:3556412378 byr:2007
      ...>
      ...> pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
      ...> hcl:#623a2f
      ...>
      ...> eyr:2029 ecl:blu cid:129 byr:1989
      ...> iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
      ...>
      ...> hcl:#888785
      ...> hgt:164cm byr:2001 iyr:2015 cid:88
      ...> pid:545766238 ecl:hzl
      ...> eyr:2022
      ...>
      ...> iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
      iex> part2(sample)
      4

      iex> Aoc2020.load_data(4) |> part2()
      194
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.filter(&has_values/1)
    |> Enum.filter(&validate/1)
    |> length()
  end

  @spec prepare_input(String.t()) :: [t()]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n\n/, trim: true)
    |> Enum.map(fn s ->
      s
      |> String.trim()
      |> String.split(~r/\s+/, trim: true)
      |> Enum.reduce(%__MODULE__{}, fn item, acc ->
        item
        |> String.split(":", trim: true, parts: 2)
        |> (fn [k, v] -> Map.put(acc, String.to_atom(k), v) end).()
      end)
    end)
  end

  defp has_values(passport) do
    passport
    |> Map.to_list()
    |> Enum.filter(fn {k, _v} -> k != :cid && k != :__struct__ end)
    |> Enum.all?(fn {_k, v} -> String.length(v) > 0 end)
  end

  defp validate(passport) do
    validate_year(passport.byr, 1920, 2002) &&
    validate_year(passport.iyr, 2010, 2020) &&
    validate_year(passport.eyr, 2020, 2030) &&
    validate_height(passport.hgt) &&
    validate_color(passport.hcl) &&
    validate_eye_color(passport.ecl) &&
    validate_pid(passport.pid)
  end

  defp validate_year(<<year::bytes-size(4)>>, low, high), do: in_range(year, low, high)
  defp validate_year(_, _, _), do: false

  defp validate_height(<<height::bytes-size(3)>> <> "cm"), do: in_range(height, 150, 193)
  defp validate_height(<<height::bytes-size(2)>> <> "in"), do: in_range(height, 59, 76)
  defp validate_height(_), do: false

  defp validate_color("#" <> <<color::bytes-size(6)>>), do: color =~ ~r/(\d|[a-f]){6}/
  defp validate_color(_), do: false

  defp validate_eye_color(color) when color in ~w(amb blu brn gry grn hzl oth), do: true
  defp validate_eye_color(_), do: false

  defp validate_pid(<<pid::bytes-size(9)>>), do: pid =~ ~r/\d{9}/
  defp validate_pid(_), do: false

  defp in_range(num, low, high) do
    num
    |> Integer.parse()
    |> elem(0)
    |> (fn y -> y in low..high end).()
  end
end
