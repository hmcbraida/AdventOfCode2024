# {:ok, s} =
#   File.read("data3.txt")

# s = String.trim(s)

# result =
#   String.split(s, "mul(")
#   |> tl()
#   |> Enum.map(fn x ->
#     String.split(x, ")")
#     |> hd()
#   end)
#   |> Enum.map(&String.split(&1, ","))
#   |> Enum.filter(fn x -> Enum.count(x) == 2 end)
#   |> Enum.map(fn x ->
#     try do
#       {String.to_integer(hd(x)), String.to_integer(hd(tl(x)))}
#     rescue
#       _ -> nil
#     end
#   end)
#   |> Enum.filter(fn x -> x != nil end)
#   |> Enum.map(fn {x, y} -> x * y end)
#   |> Enum.sum()

# IO.inspect(result)

defmodule Multiplier do
  def parse_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> ignore_dont()
    |> extract_multiplications()
    |> calculate_sum()
  end

  defp ignore_dont(content) do
    case String.split(content, "don't()") do
      [head | tail] ->
        [head | Enum.map(tail, &process_dont_block/1)]
        |> Enum.join()
    end
  end

  defp process_dont_block(content) do
    case String.split(content, "do()") do
      [_ | allowed] -> allowed
    end
  end

  defp extract_multiplications(content) do
    content
    |> String.split("mul(")
    |> tl()
    |> Enum.map(&extract_params/1)
  end

  defp extract_params(operation) do
    operation
    |> String.split(")")
    |> hd()
    |> String.split(",")
    |> parse_params()
  end

  defp parse_params([a, b]) do
    {parse_int(a), parse_int(b)}
  end

  defp parse_params(_), do: {:error, :invalid_params}

  defp parse_int(str) do
    case Integer.parse(str) do
      {num, ""} -> {:ok, num}
      _ -> {:error, :not_integer}
    end
  end

  defp calculate_sum(operations) do
    operations
    |> Enum.reduce(0, &add_if_valid/2)
  end

  defp add_if_valid({:error, _}, acc), do: acc
  defp add_if_valid({{:ok, a}, {:ok, b}}, acc), do: acc + a * b
  defp add_if_valid(_, acc), do: acc
end

result = Multiplier.parse_file("data3.txt")
IO.inspect(result)
