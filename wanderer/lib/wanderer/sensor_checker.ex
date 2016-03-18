defmodule Wanderer.SensorChecker do
  use GenServer
  require Logger
  @reset_interval 100

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
    {:ok, @reset_interval}
  end

  def handle_info({:check_on, sensors}, 0) do
    send :dj, {:check_on, sensors}
    Roombex.DJ.command(:dj, Roombex.safe())
    Roombex.DJ.command(:dj, Roombex.song(0, [[69,0.2],[71,0.2],[73,0.2]])))
    Roombex.DJ.command(:dj, Roombex.song(1, [[60,0.2],[71,0.1],[72,0.2]])))
    {:noreply, @reset_interval}
  end
  def handle_info({:check_on, sensors}, state) do
    send :dj, {:check_on, sensors}
    {:noreply, state - 1}
  end
end
