defmodule CryptoMonitor.BTC do
  @moduledoc """
  Exchange Rate Worker Monitor for Bit Coin
  """
  use GenServer

  def start_link(time) do
    GenServer.start_link(__MODULE__, time)
  end

  def init(time) do
    refresh(time)
    {:ok, %{time: time, value: 0}}
  end

  def handle_info(:refresh, state) do
    %{time: time, value: value} = state
    new_val = update_data(value)
    refresh(time)
    {:noreply, %{time: time, value: new_val}}
  end

  defp refresh(time_in_seconds) do
    Process.send_after(self(), :refresh, (time_in_seconds * 1000))
  end

  defp update_data(_current_value) do
    HTTPotion.get "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,MXN", [timeout: 15_000]
  end
end
