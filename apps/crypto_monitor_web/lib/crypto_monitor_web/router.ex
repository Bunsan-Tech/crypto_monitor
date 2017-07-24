defmodule CryptoMonitor.Web.Router do
  use CryptoMonitor.Web, :router
  alias Crypto.Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :authenticate
  end

  scope "/", CryptoMonitor.Web do
    pipe_through :browser # Use the default browser stack

    get "/", CryptoController, :index
    get "/charts", CryptoController, :charts
    get "/bussines", CryptoController, :bussines
    post "/login", CryptoController, :login
  end

  scope "/", CryptoMonitor.Web do
    pipe_through :browser # Use the default browser stack
    pipe_through :auth
    get "/balance", CryptoController, :balance
    post "/buy/:name", CryptoController, :buy_currency
  end

  # Other scopes may use custom stacks.
  # scope "/api", CryptoMonitor.Web do
  #   pipe_through :api
  # end

  defp authenticate(conn, _params) do
    if Authentication.authenticated?(conn) do
      conn
    else
      conn
      |> redirect(to: "/bussines")
      |> halt
    end
  end
end
