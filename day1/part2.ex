{:ok, body} = File.read("input.txt")

body = body |> String.split("\n", trim: true)

defmodule FuelCalculator do
  def calculate(n, acc) when floor(n / 3) - 2 >= 0 do
    next = floor(n / 3) - 2
    calculate(next, acc + next)
  end
  def calculate(_n, acc), do: acc
  def calculate(n), do: calculate(n, 0)
end

fuel = Enum.map(body, &String.to_integer/1)
       |> Enum.map(&FuelCalculator.calculate/1)
        |> Enum.sum

IO.puts(fuel)
