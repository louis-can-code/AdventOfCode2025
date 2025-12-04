defmodule Day4 do
  @adjacency [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def solve(input) do
    {paper_coords, _, _} =
      input
      |> String.graphemes()
      |> Enum.reduce({MapSet.new(), 0, 0}, fn
        "\n", {map, row, _col} -> {map, row + 1, 0}
        "@", {map, row, col} -> {MapSet.put(map, {row, col}), row, col + 1}
        _, {map, row, col} -> {map, row, col + 1}
      end)

    p1 = :timer.tc(fn -> solve_part_1(paper_coords) end)
    p2 = :timer.tc(fn -> solve_part_2(paper_coords) end)

    {p1, p2}
  end

  defp solve_part_1(papers) do
    papers
    |> MapSet.filter(fn coord ->
      coord
      |> adjacents()
      |> Enum.reduce_while(0, fn adj, count ->
        case {count, MapSet.member?(papers, adj)} do
          {3, true} -> {:halt, false}
          {count, true} -> {:cont, count + 1}
          _ -> {:cont, count}
        end
      end)
    end)
    |> MapSet.size()
  end

  defp solve_part_2(papers) do
    size = MapSet.size(papers)

    size - remove_paper(papers, size)
  end

  defp remove_paper(papers, size) do
    accessible =
      papers
      |> MapSet.reject(fn coord ->
        coord
        |> adjacents()
        |> Enum.reduce_while(0, fn adj, count ->
          case {count, MapSet.member?(papers, adj)} do
            {3, true} -> {:halt, false}
            {count, true} -> {:cont, count + 1}
            _ -> {:cont, count}
          end
        end)
      end)

    case MapSet.size(accessible) do
      ^size -> size
      smaller -> remove_paper(accessible, smaller)
    end
  end

  defp adjacents({x, y}), do: Stream.map(@adjacency, fn {dx, dy} -> {x + dx, y + dy} end)
end

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = input |> Day4.solve()
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
