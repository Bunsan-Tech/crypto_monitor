defmodule CryptoMonitor.Web.ErrorFallBackCurrencyController do
  use CryptoMonitor.Web, :controller
  alias Crypto.Currency

  def call(conn, [invalid_data: {message_error, []}]) do
    changeset = Currency.changeset(%Currency{}, %{})
    conn
      |> put_flash(:error, message_error)
      |> redirect(to: "/balance")
  end

  def call(conn, {:error, message_error}) do
    changeset = Currency.changeset(%Currency{}, %{})
    conn
      |> put_flash(:error, message_error)
      |> redirect(to: "/balance")
  end

end
