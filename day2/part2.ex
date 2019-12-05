{:ok, body} = File.read("input.txt")

body = body
       |> String.replace("\n", "")
       |> String.split(",", trim: true)
       |> Enum.map(&String.to_integer/1)

defmodule Computer do
  def process(segment, input) do
    [opcode, arg1, arg2, arg3] = Enum.at(
      Enum.chunk_every(input, 4, 4, [0, 0, 0]), segment
    )

    case opcode do
      1 ->
        {
          :cont,
          List.replace_at(
            input,
            arg3,
            Enum.at(input, arg1) + Enum.at(input, arg2)
          )
        }
      2 ->
        {
          :cont,
          List.replace_at(
            input,
            arg3,
            Enum.at(input, arg1) * Enum.at(input, arg2)
          )
        }
      99 ->
        {:halt, input}
    end
  end
end

Enum.each(1..99, fn (x) ->
  Enum.each(1..99, fn (y) ->
    input = List.replace_at(body, 1, x)
    input = List.replace_at(input, 2, y)
    result = Enum.reduce_while(
      0..Kernel.trunc((length body)/4),
      input,
      &Computer.process/2
    )
    if Enum.at(result, 0) == 19690720 do
      IO.puts(x)
      IO.puts(y)
      IO.puts(100 * x + y)
      exit(:shutdown)
    end
  end)
end)
