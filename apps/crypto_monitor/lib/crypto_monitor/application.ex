defmodule CryptoMonitor.Application do
  @moduledoc """
  The CryptoMonitor Application Service.

  The crypto_monitor system business domain lives in this application.

  Exposes API to clients such as the `CryptoMonitor.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(CryptoMonitor.Repo, []),
      supervisor(CryptoMonitor.Bank, []),
      supervisor(ConCache, [[], [name: :users]]),
      supervisor(CryptoMonitor.BTC, [5]),
      supervisor(CryptoMonitor.ETH, [5])
    ], strategy: :one_for_one, name: CryptoMonitor.Supervisor)
  end
end
