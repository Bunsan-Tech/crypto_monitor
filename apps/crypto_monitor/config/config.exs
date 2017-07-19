use Mix.Config

config :crypto_monitor, ecto_repos: [CryptoMonitor.Repo]

import_config "#{Mix.env}.exs"
