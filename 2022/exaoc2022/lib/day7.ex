defmodule ExAOC2022.Day7 do

  @input "./lib/day7_input.txt"

  @disk_size 70_000_000
  @required_space 30_000_000

  def puzzle1() do
    {_path, sizes} = analyze_file_system()
    
    Enum.reduce(sizes, 0, fn {_, v}, acc -> if v <= 100_000, do: acc + v, else: acc end)
  end

  def puzzle2() do
    {_path, sizes} = analyze_file_system()

    space_left = @disk_size - sizes["/"] 
    space_needed = @required_space - space_left

    Map.values(sizes) |> Enum.sort |> Enum.find(&(&1 >= space_needed))
  end

  defp analyze_file_system() do
    @input
    |> file_by_line
    |> Enum.map(&String.split/1)
    |> Enum.reduce({nil, %{}}, &run/2)
  end

  defp run(["$", "cd", "/"], {_, sizes}), do: {Path.rootname("/"), Map.put(sizes, "/", 0)}
  defp run(["$", "cd", ".."], {path, sizes}), do: {parent_dir(path), sizes}
  defp run(["$", "cd", dir], {path, sizes}) do 
    path = path |> Path.join(dir) 
    {path, Map.put(sizes, path, 0)}
  end
  defp run(["$", _], acc), do: acc
  defp run(["dir", _], acc), do: acc
  defp run([size, _file], {path, sizes}) do
    sizes = for {k, _v} <- sizes, reduce: sizes do
      acc ->
        if String.contains?(path, k) do
          Map.update!(acc, k, &(&1 + String.to_integer(size)))
        else 
          acc
        end
    end
    {path, sizes}
  end

  defp run(_, acc), do: acc

  defp parent_dir(path) do 
    path 
    |> Path.split() 
    |> Enum.reverse() 
    |> tl() 
    |> Enum.reverse 
    |> Path.join()
  end


  defp file_by_line(file) do
    file
    |> File.read!()
    |> String.split(~r/\R/)
  end
end
