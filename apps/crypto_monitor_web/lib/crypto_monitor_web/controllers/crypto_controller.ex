defmodule CryptoMonitor.Web.CryptoController do
  use CryptoMonitor.Web, :controller
  alias Crypto.User
  alias Crypto.Currency
  alias CryptoMonitor.Bank

  def index(conn, _params) do
    render conn, "index.html"
  end

  def charts(conn, _params) do
    render conn, "chart.html"
  end

  def bussines(conn, _params) do
    case get_session(conn, :user) do
      nil ->
        changeset = User.changeset(%User{})
        render conn, "bussines.html", changeset: changeset
      _ ->
        conn
          |> redirect(to: "/balance")
    end
  end

  def buy_currency(conn, params) do
    user = get_session(conn, :user)
    quantity =  params["currency"]["quantity"]
    currency =  params["name"]
    {quantity, _} = Integer.parse(quantity)
    Bank.buy(currency, quantity, user)
    conn
      |> redirect(to: "/balance")
  end

  def balance(conn, _params) do
    user = get_session(conn, :user)
    user_info = User.get_info(user)
    changeset = Currency.changeset(%Currency{})
    render conn, "balance.html", user_info: user_info, changeset: changeset
  end
end
