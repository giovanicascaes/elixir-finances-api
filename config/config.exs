# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :financesapp,
  ecto_repos: [Financesapp.Repo]

# Configures the endpoint
config :financesapp, FinancesappWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "skFJPX5k9RNPbgf63OZ8PGcf7JlncAgJW/4t/0V2vc5JZV2C6RHpMeHkHrP0I6AD",
  render_errors: [view: FinancesappWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Financesapp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
