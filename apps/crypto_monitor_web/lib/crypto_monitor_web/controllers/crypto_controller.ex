defmodule CryptoMonitor.Web.CryptoController do
  use CryptoMonitor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
