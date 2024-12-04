defmodule WordSearch do
  def search(filename, word) do
    matrix = filename |> load_file()

    count_word(matrix, word)
  end

  def search_cross(filename, word) do
    matrix = filename |> load_file()

    count_cross(matrix, word)
  end

  defp load_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  # I spent half an hour vexed because Elixir Enum.at wraps around: Enum.at(x, -1) == last element
  # of x.
  defp has_letter_here?(_matrix, _letter, x, y) when x < 0 or y < 0 do
    false
  end

  defp has_letter_here?(matrix, letter, x, y) do
    try do
      matrix
      |> Enum.at(x)
      |> Enum.at(y) == letter
    rescue
      _ -> false
    end
  end

  defp has_word_here_dir?(matrix, word, x, y, dir_x, dir_y) do
    word
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {letter, idx} ->
      has_letter_here?(matrix, letter, x + idx * dir_x, y + idx * dir_y)
    end)
    |> Enum.all?()
  end

  defp has_cross_half_here?(matrix, word, x, y, {dir_x, dir_y}) do
    has_word_here_dir?(matrix, word, x - dir_x, y - dir_y, dir_x, dir_y)
  end

  defp has_cross_here?(matrix, word, x, y) do
    [
      {{-1, -1}, {1, -1}},
      {{-1, -1}, {-1, 1}},
      {{1, 1}, {1, -1}},
      {{1, 1}, {-1, 1}},
      {{1, -1}, {1, 1}},
      {{1, -1}, {-1, -1}},
      {{-1, 1}, {1, 1}},
      {{-1, 1}, {-1, -1}}
    ]
    |> Enum.map(fn {dir_1, dir_2} ->
      has_cross_half_here?(matrix, word, x, y, dir_1) and
        has_cross_half_here?(matrix, word, x, y, dir_2)
    end)
    |> Enum.any?()
  end

  defp count_cross(matrix, word) do
    w = Enum.count(matrix) - 1
    h = Enum.count(Enum.at(matrix, 0)) - 1

    for x <- 0..w, y <- 0..h do
      has_cross_here?(matrix, word, x, y)
    end
    |> Enum.count(fn x -> x end)
  end

  defp count_word_here(matrix, word, x, y) do
    [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
    |> Enum.map(fn {dir_x, dir_y} -> has_word_here_dir?(matrix, word, x, y, dir_x, dir_y) end)
    |> Enum.count(fn x -> x end)
  end

  defp count_word(matrix, word) do
    w = Enum.count(matrix) - 1
    h = Enum.count(Enum.at(matrix, 0)) - 1

    for x <- 0..w, y <- 0..h do
      count_word_here(matrix, word, x, y)
    end
    |> Enum.sum()
  end
end

result = WordSearch.search_cross("data4.txt", "MAS")
# result = WordSearch.search("data4.txt", "XMAS")
IO.inspect(result)
