defmodule Wanderer.SensorChecker do
  use GenServer
  require Logger

  @sensors [
    :bumps_and_wheeldrops,
    :light_bumper,
    :buttons,
  ]

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    :timer.send_interval(33, {:check_on, @sensors})
    {:ok, %{}}
  end

  def handle_info({:check_on, sensors}, state) do
    send :dj, {:check_on, sensors}
    {:noreply, state}
  end
end
