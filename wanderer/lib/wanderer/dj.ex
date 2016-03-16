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
      listen_to: [:bumps_and_wheeldrops, :light_bumper, :buttons],
      listen_interval: 33,
      report_to: self(),
    ]
    {:ok, pid} = Roombex.DJ.start_link(opts, [name: :dj])
    {:ok, %{dj_pid: pid}}
  end

  def handle_info(msg, state) do
    Logger.debug "#{inspect msg}"
    {:noreply, state}
  end
end
