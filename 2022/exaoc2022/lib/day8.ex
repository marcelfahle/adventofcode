defmodule ExAOC2022.Day8 do
  @input "./lib/day8_input.txt"

  def puzzle1() do
    lines = file_by_line(@input)
    grid = Enum.map(lines, &(String.split(&1, "", trim: true))) 

    rows_num = length(lines)
    cols_num = hd(grid) |> length

    for i <- 0..rows_num-1, j <- 0..cols_num-1, reduce: 0 do 
      acc ->
        if visible?(grid, i, j, rows_num, cols_num), do: acc + 1, else: acc
    end
  end

  def puzzle2() do
    lines = file_by_line(@input)
    grid = Enum.map(lines, &(String.split(&1, "", trim: true))) 

    rows_num = length(lines)
    cols_num = hd(grid) |> length

    for i <- 1..rows_num-2, j <- 1..cols_num-2, reduce: 0 do 
      acc -> 
        score = scenic_score(grid, i, j, rows_num-1, cols_num-1)
        if score > acc, do: score, else: acc
    end
  end

  defp visible?(grid, x, y, max_x, max_y) do
    v = val(grid, x, y)

    cond do
      # edge
      x == 0 or y == 0 or x == (max_x - 1) or y == (max_y - 1) ->
        true    
      # up 
      max_num_y(grid, x, 0, y-1) < v ->
        true
      # down
      max_num_y(grid, x, y+1, max_y-1) < v ->
        true
      # left
      max_num_x(grid, y, 0, x-1) < v ->
        true
      # right
      max_num_x(grid, y, x+1, max_x-1) < v ->
        true
      true ->
        false
    end
  end

  defp scenic_score(grid, x, y, max_x, max_y) do
    v = val(grid, x, y)
    up_trees = Enum.map(y-1..0//-1, &val(grid, x, &1)) |> dist(v)
    left_trees = Enum.map(x-1..0//-1, &val(grid, &1, y)) |> dist(v)
    down_trees = Enum.map(y+1..max_y, &val(grid, x, &1)) |> dist(v)
    right_trees = Enum.map(x+1..max_x, &val(grid, &1, y)) |> dist(v)

    up_trees * down_trees * left_trees * right_trees
  end

  defp dist(trees, our_tree) do 
    Enum.reduce_while(trees, 0, fn tree, score -> 
      if tree >= our_tree, do: {:halt, score + 1}, else: {:cont, score + 1} 
    end) 
  end
  
  defp max_num_y(grid, x, from, to), do: 
    Enum.map(from..to, &val(grid, x, &1)) |> Enum.max() 

  defp max_num_x(grid, y, from, to), do: 
    Enum.map(from..to, &val(grid, &1, y)) |> Enum.max()

  defp int(s), do: String.to_integer(s)

  defp val(grid, x, y) do 
    get_in(grid, [Access.at(y), Access.at(x)]) |> int
  end

  defp file_by_line(file) do
    file
    |> File.read!()
    |> String.split(~r/\R/, trim: true)
  end
end
