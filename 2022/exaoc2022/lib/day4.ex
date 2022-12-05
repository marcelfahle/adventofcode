defmodule ExAOC2022.Day4 do
  @input "./lib/day4_input.txt"

  def puzzle1() do
    @input
    |> file_by_line()
    |> Enum.map(&line_to_elfarea/1)
    |> Enum.map(&subset?/1)
    |> Enum.reject(& !&1)
    |> length()
  end

  def puzzle2() do
    @input
    |> file_by_line()
    |> Enum.map(&line_to_elfarea/1)
    |> Enum.map(&intersect?/1)
    |> Enum.reject(& !&1)
    |> length()
  end

  defp line_to_elfarea(line) do
    line
    |> String.split(",")
    |> IO.inspect()
    |> Enum.map(&to_map_set/1)
  end

  defp to_map_set(area_str) do
    [first, last] = String.split(area_str, "-")

    Range.new(String.to_integer(first), String.to_integer(last)) 
    |> Enum.to_list 
    |> MapSet.new()
  end

  defp subset?([one, two]) do
    MapSet.subset?(one, two) || MapSet.subset?(two, one)
  end

  defp intersect?([one, two]) do
    MapSet.size(MapSet.intersection(one, two)) > 0
  end

  defp file_by_line(file) do
    file
    |> File.read!()
    |> String.split(~r/\R/, trim: true)
  end
end
