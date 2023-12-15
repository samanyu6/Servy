defmodule Servy.Video do
  @doc """
  simulate getting screenshot of a frame from a video cam
  """
  def get_snapshot(camera) do
    :timer.sleep(1000)
    "#{camera}-snapshot.jpg"
  end
end
