defmodule CryptoMonitor.Web.ErrorFallBackUserController do
  use CryptoMonitor.Web, :controller
  alias Crypto.User

  def call(conn, [not_found: {message_error, []}]) do
    changeset = User.changeset(%User{}, %{})
    conn
      |> put_flash(:error, message_error)
      |> render("bussines.html", changeset: changeset)
  end

  def call(conn, [wrong_pin: {message_error, []}]) do
    changeset = User.changeset(%User{}, %{})
    conn
      |> put_flash(:error, message_error)
      |> render("bussines.html", changeset: changeset)
  end
end
