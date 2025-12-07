defmodule Day6 do
  def solve(input) do
    p1 = :timer.tc(fn -> solve_part_1(input) end)
    p2 = :timer.tc(fn -> solve_part_2(input) end)

    {p1, p2}
  end

  defp solve_part_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> solve_problems_1()
  end

  defp solve_part_2(input) do
    [operators | numbers] =
      input
      |> String.split("\n", trim: true)
      |> Enum.reverse()

    operators = String.split(operators, ~r/\s+/, trim: true)

    numbers = Enum.map(numbers, &String.graphemes/1)

    solve_problems_2(operators, numbers)
  end

  defp solve_problems_1([[] | _]), do: 0

  defp solve_problems_1([["+" | rest] | numbers]) do
    answer =
      numbers
      |> Enum.map(&hd/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(0, &Kernel.+/2)

    answer + solve_problems_1([rest | Enum.map(numbers, &tl/1)])
  end

  defp solve_problems_1([["*" | rest] | numbers]) do
    answer =
      numbers
      |> Enum.map(&hd/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(1, &Kernel.*/2)

    answer + solve_problems_1([rest | Enum.map(numbers, &tl/1)])
  end

  defp solve_problems_2([], _), do: 0

  defp solve_problems_2(["+" | rest], numbers) do
    {problem, rest_of_numbers} = collect_problem(numbers)
    Enum.reduce(problem, 0, &Kernel.+/2) + solve_problems_2(rest, rest_of_numbers)
  end

  defp solve_problems_2(["*" | rest], numbers) do
    {problem, rest_of_numbers} = collect_problem(numbers)
    Enum.reduce(problem, 1, &Kernel.*/2) + solve_problems_2(rest, rest_of_numbers)
  end

  defp collect_problem([[] | _]), do: {[], nil}

  defp collect_problem(numbers) do
    num =
      numbers
      |> Enum.map(&hd/1)
      |> Enum.reverse()
      |> Enum.join()
      |> String.trim()

    case num do
      "" ->
        {[], Enum.map(numbers, &tl/1)}

      num ->
        num = String.to_integer(num)
        {problem, rest_of_numbers} = collect_problem(Enum.map(numbers, &tl/1))
        {[num | problem], rest_of_numbers}
    end
  end
end

input = Path.join(__DIR__, "input") |> File.read!()

{{t1, p1}, {t2, p2}} = Day6.solve(input)
IO.puts("Part one:\n#{p1}\ntook #{t1 / 1000}ms\n\nPart two:\n#{p2}\ntook #{t2 / 1000}ms")
