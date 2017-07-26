defmodule CryptoMonitor.Web.UserView do
  use CryptoMonitor.Web, :view
  import Plug.Conn
  def render_logout(conn) do
    case get_session(conn, :user) do
      nil ->
        ""
      _ ->
        "SALIR"
    end
  end
end
