defmodule Enumerate do
  def cards(nums, suits) do
    for n <- nums, s <- suits, do: {n, s}
  end

  def shuffle(cards) do
    cards
    |> Enum.shuffle
    |> Enum.take(13)
  end

  def chunk(cards) do
    cards
    |> Enum.shuffle
    |> Enum.chunk_every(13)
  end
end

# IO.inspect Enumerate.cards([ "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ], [ "♣", "♦", "♥", "♠" ])
#           |> Enumerate.chunk
