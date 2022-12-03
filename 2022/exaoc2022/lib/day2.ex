defmodule ExAOC2022.Day2 do
  @input "./lib/day2_input.txt"

  @x 1
  @y 2
  @z 3

  @win 6
  @loss 0
  @draw 3

  def puzzle1() do
      process(&score/1)
  end

  def puzzle2() do
      process(&cheat/1)
  end

  defp process(fun) do
    @input
    |> File.read!()
    |> String.split(~r/\R/, trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split()
      |> (&(fun.(&1))).()
      end)
    |> Enum.sum()
  end

  defp score(["A", "X"]), do: @x + @draw
  defp score(["A", "Y"]), do: @y + @win
  defp score(["A", "Z"]), do: @z + @loss

  defp score(["B", "X"]), do: @x + @loss
  defp score(["B", "Y"]), do: @y + @draw
  defp score(["B", "Z"]), do: @z + @win

  defp score(["C", "X"]), do: @x + @win
  defp score(["C", "Y"]), do: @y + @loss
  defp score(["C", "Z"]), do: @z + @draw

  defp cheat(["A", "X"]), do: score(["A", "Z"])
  defp cheat(["A", "Y"]), do: score(["A", "X"])
  defp cheat(["A", "Z"]), do: score(["A", "Y"])

  defp cheat(["B", arg]), do: score(["B", arg])

  defp cheat(["C", "X"]), do: score(["C", "Y"])
  defp cheat(["C", "Y"]), do: score(["C", "Z"])
  defp cheat(["C", "Z"]), do: score(["C", "X"])
end
