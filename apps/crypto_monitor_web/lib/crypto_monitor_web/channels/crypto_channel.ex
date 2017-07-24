defmodule CryptoMonitor.Web.CryptoChannel do
  @moduledoc """
  Channel for handling update rates events
  """
  use Phoenix.Channel

  def join("ex_monitor:rates", _message, socket) do
    {:ok, socket}
  end
  def join("ex_monitor:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
  def handle_in("btc_usd", %{"body" => body}, socket) do
    broadcast! socket, "btc_usd", %{body: body}
    {:noreply, socket}
  end
  def handle_in("btc_mxn", %{"body" => body}, socket) do
    broadcast! socket, "btc_mxn", %{body: body}
    {:noreply, socket}
  end
  def handle_out(_, payload, socket) do
    push socket, "", payload
    {:noreply, socket}
  end
end
