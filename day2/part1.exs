{:ok, body} = File.read("input.txt")

body = body
       |> String.replace("\n", "")
       |> String.split(",", trim: true)
       |> Enum.map(&String.to_integer/1)

defmodule Computer do
  def process(segment, input) do
    [instr, pos1, pos2, out_pos] = Enum.at(
      Enum.chunk_every(input, 4, 4, [0, 0, 0]), segment
    )

    case instr do
      1 ->
        {
          :cont,
          List.replace_at(
            input,
            out_pos,
            Enum.at(input, pos1) + Enum.at(input, pos2)
          )
        }
      2 ->
        {
          :cont,
          List.replace_at(
            input,
            out_pos,
            Enum.at(input, pos1) * Enum.at(input, pos2)
          )
        }
      99 ->
        {:halt, input}
    end
  end
end

result = Enum.reduce_while(
  0..Kernel.trunc((length body)/4),
  body,
  &Computer.process/2
)

IO.inspect(result)
