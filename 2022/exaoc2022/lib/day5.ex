defmodule ExAOC2022.Day5 do
  @input "./lib/day5_input.txt"

  def puzzle1() do
    {initial_state, instructions} = init()

    new_state = Enum.reduce(instructions, initial_state, &run_instructions/2)
    
    get_top_boxes(new_state)
  end

  def puzzle2() do
    {initial_state, instructions} = init()

    new_state = Enum.reduce(instructions, initial_state, &(run_instructions(&1, &2, true)))
    
    get_top_boxes(new_state)
  end

  #
  #
  # private shenanigans
  #
  # loads data and sets up initial state
  defp init() do
    [port, _, instructions, _rest] =
      @input
      |> file_by_line()
      |> Enum.chunk_by(&(&1 == ""))

    {parse_state(Enum.reverse(port)), instructions}
  end

  # runs instructions duh
  defp run_instructions(instr, state, batch_process? \\ false) do
    [[times], [from_id], [to_id]] = Regex.scan(~r/\d+/, instr)
    
    src_stack = state[from_id] 
    trgt_stack = state[to_id] 

    {updated_trgt, updated_src} = for _i <- 1..String.to_integer(times), reduce: {[], src_stack} do
      {trgt_acc, src_acc} -> 
        {box, new_src} = pop(src_acc) 
        new_trgt = push(trgt_acc, box)

        {new_trgt, new_src}
    end
    
    updated_trgt = if batch_process?, do: Enum.reverse(updated_trgt), else: updated_trgt

    state
    |> Map.put(from_id, updated_src)
    |> Map.put(to_id, updated_trgt ++ trgt_stack)
  end 

  # returns top box from each stack
  defp get_top_boxes(state) do
    for {_, stack} <- state do
      {top_item, _} = pop(stack)
      top_item
    end
    |> Enum.join
  end

  defp parse_state([head | rest]) do
    initial_map = create_map(head)

    rest
    |> Enum.reduce(initial_map, fn row, state -> 
      parsed_row = parse_row(row)

      for {val, stack_id} <- parsed_row, reduce: state do
        acc -> 
          if val !== "", do: Map.update(acc, "#{stack_id}", [], fn stack -> push(stack, val) end), else: acc
      end
    end)
  end

  # turns a state row into something usable
  defp parse_row(row) do
    row
    |> String.graphemes
    |> Enum.chunk_every(4)
    |> Enum.map(&extract_box_id/1)
    |> Enum.with_index(1)
  end

  defp extract_box_id(box_info), do: box_info |> Enum.join() |> String.replace(~r/[^A-Z]/, "")

  # initializes the state map based on the input data
  defp create_map(head) do
    head 
    |> String.trim() 
    |> String.split() 
    |> Map.from_keys([])
  end
  
  # stack stack stack
  defp push(stack, item) do
    [item | stack] 
  end

  defp pop([item | rest]) do
    {item, rest}
  end
  
  defp file_by_line(file) do
    file
    |> File.read!()
    |> String.split(~r/\R/)
  end
end
