defmodule ExAOC2022.Day3 do
  @input "./lib/day3_input.txt"

  def puzzle1() do
    prio = priority_map([?a..?z, ?A..?Z])

    @input
    |> file_by_line()
    |> Enum.map(&by_compartment/1)
    |> Enum.map(&eq/1)
    |> Enum.map(&Keyword.get(prio, String.to_atom(&1)))
    |> Enum.sum()
  end

  def puzzle2() do
    prio = priority_map([?a..?z, ?A..?Z])

    @input
    |> file_by_line()
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_chars/1)
    |> Enum.map(&Keyword.get(prio, String.to_atom(&1)))
    |> Enum.sum()
  end

  # PRIVATE SHENANIGANS
  defp by_compartment(content) do
    mid_len = content |> String.length() |> div(2)

    content |> String.split_at(mid_len)
  end

  defp eq({str1, str2}), do: String.myers_difference(str1, str2)[:eq]

  defp find_common_chars(list_of_strings) do
    list_of_strings
    |> Enum.map(&uniq/1)
    |> Enum.join()
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.filter(fn {_k, v} -> v == 3 end)
    |> Map.keys()
    |> List.first()
  end

  defp uniq(str) do
    str
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.join()
  end

  defp priority_map(ranges) do
    ranges
    |> Enum.map(&priority/1)
    |> Enum.concat()
    |> Enum.with_index(1)
  end

  defp priority(range) do
    range
    |> Enum.map(&String.to_atom(<<&1::utf8>>))
  end

  defp file_by_line(file) do
    file
    |> File.read!()
    |> String.split(~r/\R/, trim: true)
  end
end
