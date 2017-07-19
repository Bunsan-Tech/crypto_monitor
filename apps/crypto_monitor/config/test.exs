use Mix.Config

# Configure your database
config :crypto_monitor, CryptoMonitor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "crypto_monitor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
