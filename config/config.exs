# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :identity,
  ecto_repos: [Repo]

config :web,
  generators: [context_app: :identity]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C5yjVxZmqfiFB6/QrOs55DFE74y/iLAnE9hRtkr8rRGdCb8T8QXFrZqlEDRXwUtf",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Messaging.PubSub,
  live_view: [signing_salt: "PgAKPnNF"]

# Configure Mix tasks and generators
config :repo,
  ecto_repos: [Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :copper_api,
  copper_api_token: System.get_env("COPPER_TOKEN"),
  copper_api_email: System.get_env("COPPER_EMAIL")

config :sighten_api,
  sighten_api_token: System.get_env("SIGHTEN_TOKEN")

config :hubspot_api,
  env: Mix.env(),
  hubspot_api_token: System.get_env("HUBSPOT_TOKEN")

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")

config :sitecapture_api, api_token: System.get_env("SITECAPTURE_TOKEN")

config :sitecapture_api, authorization_token: System.get_env("SITECAPTURE_AUTHORIZATION")

config :pandadoc_api, api_token: System.get_env("PANDADOC_TOKEN"), env: Mix.env()

config :zenefits_api, api_token: System.get_env("ZENEFITS_API_KEY"), env: Mix.env()

config :skyline_oban, Oban,
  # peer: false,
  repo: Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 7_889_238},
    Oban.Plugins.Repeater
  ],
  # queues: false
  queues: [
    default: 5,
    skyline_sales: 5,
    skyline_proposals: 5,
    skyline_operations: 50,
    collectors: 10,
    long_updater: 10
  ]

config :netsuite_api,
  env: Mix.env()

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [
         hd: "org",
         prompt: "select_account",
         access_type: "offline",
         include_granted_scopes: true
       ]}
  ]

config :skyline_operations,
  env: Mix.env()

config :skyline_google,
  env: Mix.env()

config :tailwind,
  version: "3.0.23",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../apps/web/assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
