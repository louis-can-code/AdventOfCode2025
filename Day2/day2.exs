defmodule Day2 do
  def solve(input) do
    id_ranges =
      input
      |> String.split(",")
      |> Enum.map(fn id_range ->
        [_, first_id, last_id] = Regex.run(~r/^(\d+)-(\d+)$/, id_range)
        {first_id, last_id}
      end)

    p1 = :timer.tc(fn -> solve_part_1(id_ranges) end)
    # p2 = :timer.tc(fn -> solve_part_2(id_ranges) end)
    p2 = {0, 0}

    {p1, p2}
  end

  defp solve_part_1([]), do: 0

  defp solve_part_1([{first_id, last_id} | rest]) do
    last_id = String.to_integer(last_id)

    # split the first id in half, in order to generate invalid ids
    repeater =
      if rem(String.length(first_id), 2) != 0 do
        10 ** div(String.length(first_id), 2)
      else
        {h1, h2} =
          first_id
          |> String.split_at(div(String.length(first_id), 2))

        {h1, h2} = {String.to_integer(h1), String.to_integer(h2)}

        if h2 > h1, do: h1 + 1, else: h1
      end

    # generate stream of invalid ids, take from stream until out of range, sum
    invalid_id_sum =
      Stream.iterate({repeater, "#{repeater}#{repeater}"}, fn {x, _} ->
        {x + 1, "#{x + 1}#{x + 1}"}
      end)
      |> Stream.map(fn {_, x} -> x end)
      |> Stream.map(&String.to_integer/1)
      |> Stream.take_while(&(&1 <= last_id))
      |> Enum.sum()

    invalid_id_sum + solve_part_1(rest)
  end

  defp solve_part_2([]), do: 0

  defp solve_part_2([{first_id, last_id} | rest]) do
    last_id = String.to_integer(last_id)

    # I will attempt to adapt my part 1 solution, s.t. it constructs streams for 1..len/2 size repeaters
    # This is currently breaking my brain slightly, so will come back to it tomorrow
  end
end

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = input |> Day2.solve()
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
