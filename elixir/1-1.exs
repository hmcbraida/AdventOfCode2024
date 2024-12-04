{:ok, s} = File.read("data1.txt")

data = String.split(s, "\n")
  |> Enum.reverse() |> tl() |> Enum.reverse()
  |> Enum.map(&String.split(&1, "   "))

col1 = Enum.map(data, fn row -> String.to_integer(Enum.at(row, 0)) end)
  |> Enum.sort()
col2 = Enum.map(data, fn row -> String.to_integer(Enum.at(row, 1)) end)
  |> Enum.sort()

sum = Enum.zip(col1, col2)
  |> Enum.map(fn {x, y} -> abs(x - y) end)
  |> Enum.sum()

IO.inspect(sum)
