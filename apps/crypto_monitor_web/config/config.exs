# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :crypto_monitor_web,
  namespace: CryptoMonitor.Web,
  ecto_repos: [CryptoMonitor.Repo]

# Configures the endpoint
config :crypto_monitor_web, CryptoMonitor.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QjJ9YmTqlOsSdkTFqpDFzwdZ6JuAcWjr7VU8IezBOsis5SKNi8WmtF0HEwJ0LqM2",
  render_errors: [view: CryptoMonitor.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CryptoMonitor.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :crypto_monitor_web, :generators,
  context_app: :crypto_monitor

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
