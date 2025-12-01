defmodule Day1 do
  def solve(input) do
    input = String.split(input, "\n", trim: true)

    p1 = :timer.tc(fn -> solve_part_1(input, 50) end)
    p2 = :timer.tc(fn -> solve_part_2(input, 50) end)

    {p1, p2}
  end

  defp solve_part_1([], _), do: 0

  defp solve_part_1([<<direction::binary-size(1), clicks::binary>> | rest], pointing_at) do
    pointing_at = if direction == "L", do: 100 - pointing_at, else: pointing_at

    turn_dial = pointing_at + String.to_integer(clicks)

    new_pointing_at =
      if direction == "R" do
        rem(turn_dial, 100)
      else
        mod(100 - turn_dial, 100)
      end

    zero = if new_pointing_at == 0, do: 1, else: 0

    zero + solve_part_1(rest, new_pointing_at)
  end

  defp solve_part_2([], _), do: 0

  defp solve_part_2([<<direction::binary-size(1), clicks::binary>> | rest], pointing_at) do
    pointing_at = if direction == "L", do: 100 - pointing_at, else: pointing_at

    turn_dial = pointing_at + String.to_integer(clicks)

    no_of_zero_crosses = div(turn_dial, 100)

    # avoid double-counting when turning left from 0
    no_of_zero_crosses =
      if pointing_at == 100 do
        no_of_zero_crosses - 1
      else
        no_of_zero_crosses
      end

    new_pointing_at =
      if direction == "R" do
        rem(turn_dial, 100)
      else
        mod(100 - turn_dial, 100)
      end

    no_of_zero_crosses + solve_part_2(rest, new_pointing_at)
  end

  # like rem but accounts for negatives:
  # if x < 0, adding n gives us a positive answer
  # if x >= 0, second call to rem ensures output < n
  defp mod(x, n), do: rem(rem(x, n) + n, n)
end

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = input |> Day1.solve()
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
