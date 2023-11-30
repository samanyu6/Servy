defmodule Rex do
  def triple([head | tail], arr) do
    triple(tail, [head*3 | arr])
  end

  def triple([], arr), do: arr
end

IO.inspect Rex.triple([1, 2, 3, 4, 5], [])
