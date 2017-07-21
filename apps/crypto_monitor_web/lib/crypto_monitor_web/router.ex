defmodule CryptoMonitor.Web.Router do
  use CryptoMonitor.Web, :router

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

  scope "/", CryptoMonitor.Web do
    pipe_through :browser # Use the default browser stack

    get "/", CryptoController, :index
    get "/charts", CryptoController, :charts
  end

  # Other scopes may use custom stacks.
  # scope "/api", CryptoMonitor.Web do
  #   pipe_through :api
  # end
end
