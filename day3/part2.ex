{:ok, body} = File.read("input.txt")

paths = body |> String.split("\n", trim: true)

wire_1 = Enum.at(paths, 0) |> String.split(",", trim: true)
wire_2 = Enum.at(paths, 1) |> String.split(",", trim: true)

defmodule Circuit do
  def process_path(path, grid) do
    {direction, amount} = String.split_at(path, 1)
    amount = String.to_integer(amount)
    position = List.last(grid)
    grid ++ Enum.flat_map(1..amount, fn i ->
      case direction do
        "L" ->
          [put_elem(position, 0, elem(position, 0) - i)]
        "R" ->
          [put_elem(position, 0, elem(position, 0) + i)]
        "D" ->
          [put_elem(position, 1, elem(position, 1) - i)]
        "U" ->
          [put_elem(position, 1, elem(position, 1) + i)]
      end
    end)
  end
  def calculate_steps(point, positions), do: Enum.find_index(positions, fn x -> x == point end)
  def calculate_manhattan_distance(point), do: abs(elem(point, 0)) + abs(elem(point, 1))
  def intersect(a, b), do: a -- (a -- b)
end

wire_1_positions = Enum.reduce(wire_1, [{0, 0}], &Circuit.process_path/2)
wire_2_positions = Enum.reduce(wire_2, [{0, 0}], &Circuit.process_path/2)
crosses = Circuit.intersect(wire_1_positions, wire_2_positions) -- [{0, 0}]
steps = Enum.map(crosses, fn cross ->
  {cross, Circuit.calculate_steps(cross, wire_1_positions) + Circuit.calculate_steps(cross, wire_2_positions)}
end)

IO.puts(Enum.min(Enum.map(steps, fn x -> elem(x, 1) end)))
