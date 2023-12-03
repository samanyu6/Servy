defmodule Rex do
  def triple(arr) do
    Enum.map(arr, fn(c) -> c*3  end)
  end
end

IO.inspect Rex.triple([1, 2, 3, 4, 5])
