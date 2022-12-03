defmodule ExAOC2022.Day1 do
  @input "./lib/day1_input.txt"

  def puzzle1() do
    calories = File.read!(@input)

    calories
    |> sum_of_all_cals_by_elf()
    |> Enum.max()
  end

  def puzzle2() do
    calories = File.read!(@input)

    calories
    |> sum_of_all_cals_by_elf()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp sum_of_all_cals_by_elf(calories) do
    calories
    |> String.split(~r/\R/)
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""] || &1 == ["", ""]))
    |> Enum.map(fn list ->
      list
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end
end
