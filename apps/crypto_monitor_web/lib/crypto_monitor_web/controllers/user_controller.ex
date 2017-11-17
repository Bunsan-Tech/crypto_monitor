defmodule CryptoMonitor.Web.UserController do
  use CryptoMonitor.Web, :controller

  def signup(conn, _params) do
    conn
      |> text("Setup user sign up flow")
  end
end
