chunker = fn
  elem, [] -> {:cont, [elem]}
  elem, [prev | _] = acc when prev == elem -> {:cont, [elem | acc]}
  elem, acc -> {:cont, Enum.reverse(acc), [elem]}
end

after_chunker = fn
  [] -> {:cont, []}
  acc -> {:cont, Enum.reverse(acc), []}
end

part1 =
  Enum.filter(172930..683082, fn i ->
    Integer.to_string(i)
    |> String.codepoints
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_while([], chunker, after_chunker)
    |> Enum.any?(fn x -> length(x) > 1 end)
  end)
  |> Enum.filter(fn i ->
    i == Integer.to_string(i)
    |> String.codepoints
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort
    |> Enum.join
    |> String.to_integer
  end)
  |> Enum.count

IO.puts(part1)

part2 =
  Enum.filter(172930..683082, fn i ->
    Integer.to_string(i)
    |> String.codepoints
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_while([], chunker, after_chunker)
    |> Enum.any?(fn x -> length(x) == 2 end)
  end)
  |> Enum.filter(fn i ->
    i == Integer.to_string(i)
    |> String.codepoints
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort
    |> Enum.join
    |> String.to_integer
  end)
  |> Enum.count

IO.puts(part2)

