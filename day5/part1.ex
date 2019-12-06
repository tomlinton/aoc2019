# Credit mhinz https://gist.github.com/mhinz/af04e13207e9631795f89ada11d407a2

defmodule Computer do
  def run(), do: run(mem(), 0)

  defp run(mem, ip) do
    ins = parse_instruction(mem[ip])
    a1  = if ins[:m1] == 1, do: ip+1, else: mem[ip+1]
    a2  = if ins[:m2] == 1, do: ip+2, else: mem[ip+2]
    a3  = if ins[:m3] == 1, do: ip+3, else: mem[ip+3]

    case ins[:op] do
      1  -> op_add(mem, a1, a2, a3)       |> run(ip+4)
      2  -> op_mult(mem, a1, a2, a3)      |> run(ip+4)
      3  -> op_input(mem, a1)             |> run(ip+2)
      4  -> op_output(mem, a1)            |> run(ip+2)
      5  -> mem                           |> run(op_jump_if_true(mem, ip, a1, a2))
      6  -> mem                           |> run(op_jump_if_false(mem, ip, a1, a2))
      7  -> op_less_than(mem, a1, a2, a3) |> run(ip+4)
      8  -> op_equal(mem, a1, a2, a3)     |> run(ip+4)
      99 -> true
      _  -> run(mem, ip+4)
    end
  end

  defp op_add(mem, a1, a2, a3),  do: Map.put(mem, a3, mem[a1] + mem[a2])
  defp op_mult(mem, a1, a2, a3), do: Map.put(mem, a3, mem[a1] * mem[a2])

  defp op_input(mem, a1) do
    n = IO.gets("") |> String.trim() |> String.to_integer()
    Map.put(mem, a1, n)
  end

  defp op_output(mem, a1) do
    IO.inspect(mem[a1])
    mem
  end

  defp op_jump_if_true(mem, ip, a1, a2),  do: if(mem[a1] != 0, do: mem[a2], else: ip+3)
  defp op_jump_if_false(mem, ip, a1, a2), do: if(mem[a1] == 0, do: mem[a2], else: ip+3)

  defp op_less_than(mem, a1, a2, a3), do: Map.put(mem, a3, if(mem[a1] <  mem[a2], do: 1, else: 0))
  defp op_equal(mem, a1, a2, a3),     do: Map.put(mem, a3, if(mem[a1] == mem[a2], do: 1, else: 0))

  defp parse_instruction(instruction) do
    ins = instruction |> Integer.digits() |> fill()
    %{
      m3: Enum.fetch!(ins, 0),
      m2: Enum.fetch!(ins, 1),
      m1: Enum.fetch!(ins, 2),
      op: Enum.slice(ins, 3, 2) |> Enum.join() |> String.to_integer()
    }
  end

  defp fill(list), do: if(length(list) < 5, do: fill([0 | list]), else: list)

  defp mem do
    "program.txt"
    |> File.read!
    |> String.trim
    |> String.split(",")
    |> Enum.with_index
    |> Enum.map(fn {val, idx} -> {idx, String.to_integer(val)} end)
    |> Map.new()
  end
end

Computer.run()
