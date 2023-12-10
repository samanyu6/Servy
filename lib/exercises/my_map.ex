defmodule MyMap do
  def my_map([head | tail], func) do
    [func.(head) | my_map(tail, func)]
  end

  def my_map([], __func), do: []
end

IO.inspect MyMap.my_map([1, 2, 3, 4, 5], &(&1 * 5))
