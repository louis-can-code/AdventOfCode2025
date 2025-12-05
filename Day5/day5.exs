defmodule Day5 do
  def solve(input) do
    {ranges, food, _} =
      input
      |> String.split("\n")
      |> Enum.reduce({{[], []}, [], :ranges}, fn
        "", {ranges, food, _} ->
          {ranges, food, :food}

        string, {ranges, [], :ranges} ->
          [_, first, last] = Regex.run(~r/^(\d+)-(\d+)$/, string)
          range = {String.to_integer(first), String.to_integer(last)}
          {add_range(ranges, range), [], :ranges}

        string, {ranges, food, :food} ->
          {ranges, [String.to_integer(string) | food], :food}
      end)

    p1 = :timer.tc(fn -> solve_part_1(ranges, food) end)
    p2 = :timer.tc(fn -> solve_part_2(ranges) end)

    {p1, p2}
  end

  defp solve_part_1(ranges, food) do
    Enum.reduce(food, 0, fn item, acc -> acc + fresh_flag(ranges, item) end)
  end

  defp solve_part_2({[], []}), do: 0

  # sum the size of each range, achieved by end - start of range plus one (bcs inclusive)
  defp solve_part_2({[first | startpoints], [last | endpoints]}) do
    last - first + 1 + solve_part_2({startpoints, endpoints})
  end

  defp fresh_flag({[], []}, _), do: 0

  defp fresh_flag({[startpoint | startpoints], [endpoint | endpoints]}, item) do
    cond do
      item > endpoint -> fresh_flag({startpoints, endpoints}, item)
      item < startpoint -> 0
      true -> 1
    end
  end

  defp add_range({[], []}, {first, last}), do: {[first], [last]}

  defp add_range({[startpoint | startpoints], [endpoint | endpoints]}, {first, last}) do
    cond do
      # range is larger than current range, so add further up the structure
      first > endpoint ->
        {range_starts, range_ends} = add_range({startpoints, endpoints}, {first, last})
        {[startpoint | range_starts], [endpoint | range_ends]}

      # range is smaller than current range, so prepend it
      last < startpoint ->
        {[first, startpoint | startpoints], [last, endpoint | endpoints]}

      # superset
      first <= startpoint and last >= endpoint ->
        add_range({startpoints, endpoints}, {first, last})

      # subset so this range is already covered
      first >= startpoint and last <= endpoint ->
        {[startpoint | startpoints], [endpoint | endpoints]}

      # overlaps extending beginning of the range
      first < startpoint ->
        {[first | startpoints], [endpoint | endpoints]}

      # overlaps extending end of the range
      # this could leak into next range, so compare further
      last > endpoint ->
        add_range({startpoints, endpoints}, {startpoint, last})
    end
  end
end

# too low

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = input |> Day5.solve()
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
