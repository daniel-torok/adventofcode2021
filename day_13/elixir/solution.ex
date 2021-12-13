to_coord = fn str ->
  [x, y] = str |> :binary.split(",") |> Enum.map(&String.to_integer/1)
  %{x: x, y: y}
end

to_instruction = fn str ->
  [axis, fold_at] = str |> :binary.split("=")
  %{axis: String.to_atom(axis), fold_at: String.to_integer(fold_at)}
end

fold = fn (instruction, coords) ->
  %{axis: axis, fold_at: fold_at} = instruction
  {first, second} = coords |> Enum.split_with(&(&1[axis] > fold_at))
  MapSet.union(MapSet.new(second), MapSet.new(first, &(%{ &1 | axis => fold_at - (&1[axis] - fold_at) })))
end

puts_matrix = fn marks ->
  x = Enum.max_by(marks, &(&1.x)).x
  y = Enum.max_by(marks, &(&1.y)).y
  for row <- (0..y) do
    for col <- (0..x) do
      case MapSet.member?(marks, %{x: col, y: row}) do
        true -> IO.write "X"
        false -> IO.write " "
      end
    end
    IO.puts ""
  end
end

coords = File.read!("coords.data") |> :binary.split("\n", [:global]) |> Enum.map(to_coord) |> MapSet.new
instructions = File.read!("instructions.data") |> :binary.split("\n", [:global]) |> Enum.map(to_instruction)

IO.puts "First: " <> (fold.(List.first(instructions), coords) |> MapSet.size |> to_string)
IO.puts "Second: "; puts_matrix.(List.foldl(instructions, coords, fold))
