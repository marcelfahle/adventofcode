defmodule ExAOC2022.Day6 do
  @input "./lib/day6_input.txt"
  

  def puzzle1() do
    @input
    |> File.read!()
    |> distinct_chars_idx(4)
  end
  
  def puzzle2() do
    @input
    |> File.read!()
    |> distinct_chars_idx(14)
  end

  defp distinct_chars_idx(str, len) do
    str
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce_while([], fn {char, idx}, acc ->
      if length(acc) < len do
        {:cont, [char | acc]}
      else
        if has_dups?(acc) do
          {:cont, [char | shorten(acc)]} 
        else 
          {:halt, idx}
        end

      end 
    end)
  end

  defp has_dups?(list), do: Enum.uniq(list) != list
  defp shorten(list), do: list |> Enum.reverse() |> tl() |> Enum.reverse()

end
