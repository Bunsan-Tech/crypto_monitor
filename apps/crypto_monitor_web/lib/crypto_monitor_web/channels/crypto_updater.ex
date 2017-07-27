defmodule CryptoMonitor.Updater do
  @moduledoc """
  Module for receive updates from bank
  """
  use GenServer
  alias CryptoMonitor.Web.Endpoint, as: CryptoSocket

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def handle_call({:update, currency, value}, _from, state) do
    CryptoSocket.broadcast("ex_monitor:rates", currency, %{"body": value})
    {:reply, :ok, state}
  end
end
