defmodule Stable do
  def is_stable?(list) do
    Enum.zip(tl(list), list)
    |> Enum.map(fn {x, y} -> x - y end)
    |> (fn x ->
          (Enum.all?(x, fn x -> x > 0 end) or
             Enum.all?(x, fn x -> x < 0 end)) and
            Enum.all?(x, fn x -> abs(x) < 4 end)
        end).()
  end

  def is_almost_stable?(list) do
    0..Enum.count(list)
    |> Enum.map(fn n ->
      Enum.with_index(list)
      |> Enum.reject(fn {_, i} -> i == n end)
      |> Enum.map(fn {x, _} -> x end)
      |> Stable.is_stable?()
    end)
    |> Enum.any?()
  end
end

{:ok, s} = File.read("data2.txt")

data =
  String.split(s, "\n")
  |> Enum.reverse()
  |> tl()
  |> Enum.reverse()
  |> Enum.map(fn x ->
    String.split(x)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end)

# IO.inspect(data)

success_count = Enum.count(data, &Stable.is_almost_stable?(&1))
failure_count = Enum.count(data, &(not Stable.is_almost_stable?(&1)))

IO.inspect(success_count)
IO.inspect(failure_count)

success_count = Enum.count(data, &Stable.is_stable?(&1))
failure_count = Enum.count(data, &(not Stable.is_stable?(&1)))

IO.inspect(success_count)
IO.inspect(failure_count)
