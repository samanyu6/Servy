defmodule Recurse do
  def sum([head | tail], ans) do
      sum(tail, ans+head)
  end

  def sum([], ans), do: ans
end

IO.puts Recurse.sum([1, 2, 3, 4, 5, 6], 0)
