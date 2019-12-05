{:ok, body} = File.read("input.txt")

body = body |> String.split("\n", trim: true)

calculate_fuel_required = fn (m) -> floor((m / 3)) - 2 end

total = Enum.map(body, &String.to_integer/1)
  |> Enum.map(calculate_fuel_required)
  |> Enum.sum

IO.puts(total)
