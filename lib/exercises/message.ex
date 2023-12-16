defmodule Exercises.Send do
  def power_nap() do
    time = :rand.uniform(10_000)
    :timer.sleep(time)
    time
  end
end

defmodule Exercises.Receive do
  parent = self()

  spawn(fn -> send(parent, {:slept, Exercises.Send.power_nap}) end)

  receive do
    {:slept, time} -> IO.puts "Sleep #{time}"
      # code
  end

end
