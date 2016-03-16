defmodule Wanderer.Listener do
  require Logger

  def start_link do
    {:ok, spawn_link(__MODULE__, :init, [])}
  end

  def init do
    {:ok, socket} = :gen_udp.open(10_000, [:binary])
    Logger.debug("listening for UDP messages on port 10_000")
    loop(socket)
  end

  defp loop(socket) do
    receive do
      {:udp, _sock, _from_ip, _from_port, msg} -> handle_udp(msg)
      msg -> Logger.error("Received unexpected message in #{__MODULE__}", msg)
    end
    loop(socket)
  end

  defp handle_udp("go"), do: GenServer.cast(Wanderer.DJ, :go)
  defp handle_udp("stop"), do: GenServer.cast(Wanderer.DJ, :stop)
  defp handle_udp(msg) do
    Logger.debug("??? #{msg}")
  end
end
