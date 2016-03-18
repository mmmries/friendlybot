defmodule Wanderer.DJ do
  use GenServer
  require Logger
  @wandering_speed 100
  @backup_speed -50
  @tight_turn_right -50
  @tight_turn_left 50
  @loose_turn_right -70
  @loose_turn_left 70

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
    {:ok, %{dj_pid: pid, roomba: Roombex.State, wandering: true}}
  end

  def handle_cast(:go, state) do
    drive(@wandering_speed, 0)
    {:noreply, %{state | wandering: true}}
  end
  def handle_cast(:stop, state) do
    drive(0, 0)
    Roombex.DJ.command(:dj, Roombex.play(0))
    {:noreply, %{state | wandering: false}}
  end
  def handle_cast(:sing, state) do
    Roombex.DJ.command(:dj, Roombex.play(1))
    {:noreply, state}
  end

  def handle_info({:roomba_status, roomba}, state) do
    state = %{state | roomba: roomba}
    update_drive(state)
    {:noreply, state}
  end
  def handle_info(msg, state) do
    Logger.debug "unexpected message #{inspect msg}"
    {:noreply, state}
  end

  defp update_drive(%{wandering: false}), do: nil
  defp update_drive(%{roomba: roomba}) do
    react_to(roomba)
  end

  defp drive(velocity, radius) do
    Roombex.DJ.command(:dj, Roombex.drive(velocity, radius))
  end

  defp on_the_left?(%{light_bumper_left: 1}), do: true
  defp on_the_left?(%{light_bumper_left_front: 1}), do: true
  defp on_the_left?(_), do: false

  defp on_the_right?(%{light_bumper_right: 1}), do: true
  defp on_the_right?(%{light_bumper_right_front: 1}), do: true
  defp on_the_right?(_), do: false

  defp react_to(%{bumper_left: 1, bumper_right: 1}), do: drive(@backup_speed, 0)
  defp react_to(%{bumper_left: 1, bumper_right: 0}), do: drive(@backup_speed, @tight_turn_left)
  defp react_to(%{bumper_left: 0, bumper_right: 1}), do: drive(@backup_speed, @tight_turn_right)
  defp react_to(sensors) do
    cond do
      up_front?(sensors) -> drive(div(@wandering_speed, 3), @tight_turn_right)
      on_the_left?(sensors) -> drive(div(@wandering_speed, 2), @loose_turn_right)
      on_the_right?(sensors) -> drive(div(@wandering_speed, 2), @loose_turn_left)
      true -> drive(@wandering_speed,0)
    end
  end

  defp up_front?(%{light_bumper_left_center: 1}), do: true
  defp up_front?(%{light_bumper_right_center: 1}), do: true
  defp up_front?(_), do: false
end
