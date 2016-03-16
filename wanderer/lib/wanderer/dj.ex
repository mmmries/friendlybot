defmodule Wanderer.DJ do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init([]) do
    opts = [
      tty: System.get_env("SERIAL") || '/dev/ttyUSB0',
      speed: 115_200,
      report_to: self(),
    ]
    {:ok, pid} = Roombex.DJ.start_link(opts, [name: :dj])
    {:ok, %{dj_pid: pid, roomba: Roombex.State}}
  end

  def handle_info({:roomba_status, roomba}, state) do
    sensor_change(state.roomba, roomba)
    {:noreply, %{state | roomba: roomba}}
  end
  def handle_info(msg, state) do
    Logger.debug "unexpected message #{inspect msg}"
    {:noreply, state}
  end

  def sensor_change(%{button_hour: 0}, %{button_hour: 1}) do
    Logger.debug "hour button pressed"
  end
  def sensor_change(%{button_hour: 0}, %{button_hour: 1}) do
    Logger.debug "hour button released"
  end
  def sensor_change(_old, _new), do: nil
end
