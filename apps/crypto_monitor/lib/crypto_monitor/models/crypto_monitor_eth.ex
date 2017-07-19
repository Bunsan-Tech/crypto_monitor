defmodule CryptoMonitor.ETH do
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

  defp update_data(current_value) do
    response = HTTPotion.get "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,MXN"
    if response.status_code == 200 do
      %{"MXN" => mxn, "USD" => usd} = Poison.decode!(response.body)
      CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_usd", %{"body": usd})
      CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_mxn", %{"body": mxn})
      cond do
        usd > current_value ->
          CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_img", %{"body": "/images/up_arrow.png"})
        usd < current_value ->
          CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_img", %{"body": "/images/down_arrow.png"})
        true ->
          CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_img", %{"body": "/images/even.png"})
      end
      usd
    else
      CryptoMonitor.Web.Endpoint.broadcast("ex_monitor:rates", "eth_img", %{"body": "/images/even.png"})
      current_value
    end
  end
end