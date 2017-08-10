use Mix.Config

# Configure your database
config :crypto_monitor, CryptoMonitor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "crypto_monitor_dev",
  hostname: "localhost",
  pool_size: 10

config :crypto_monitor, CryptoMnesiaMonitor.Repo,
  adapter: EctoMnesia.Adapter,
  priv: "priv/mnesia_repo" #Custom path for load create and run migrations
