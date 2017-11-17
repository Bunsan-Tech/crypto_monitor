defmodule CryptoMonitor.Web.CryptoController do
  use CryptoMonitor.Web, :controller

  action_fallback CryptoMonitor.Web.ErrorFallBackCurrencyController

  def index(conn, _params) do
    conn
      |> text("Bienvenidos al taller de phoenix")
  end

end
