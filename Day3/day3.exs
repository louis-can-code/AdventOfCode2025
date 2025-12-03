defmodule Day3 do
  def solve(input) do
    banks = String.split(input, "\n", trim: true)

    p1 = :timer.tc(fn -> solve_part_1(banks) end)
    p2 = :timer.tc(fn -> solve_part_2(banks) end)

    {p1, p2}
  end

  defp solve_part_1(banks) do
    Enum.map(banks, fn bank ->
      {digit1, digit2} =
        bank
        |> String.graphemes()
        |> Enum.reduce({-1, -1}, fn
          battery, {d1, d2} when d2 > d1 -> {d2, battery}
          battery, {d1, d2} when battery > d2 -> {d1, battery}
          _, {d1, d2} -> {d1, d2}
        end)

      String.to_integer("#{digit1}#{digit2}")
    end)
    |> Enum.sum()
  end

  defp solve_part_2(banks) do
    Enum.map(banks, fn bank ->
      bank
      |> String.graphemes()
      |> Enum.reduce(List.duplicate(-1, 12), &rearrange_active_batteries/2)
      |> Enum.reverse()
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  # "active" batteries initialised as 12 -1s
  # read through left to right (with battery on the end)
  # if any left < right, remove left, add battery to end
  # if no left < right, ignore battery
  defp rearrange_active_batteries(battery, [last]) do
    if last < battery do
      [battery]
    else
      [last]
    end
  end

  defp rearrange_active_batteries(battery, [first, second | rest]) do
    if first < second do
      [second | rest] ++ [battery]
    else
      [first | rearrange_active_batteries(battery, [second | rest])]
    end
  end
end

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = input |> Day3.solve()
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
