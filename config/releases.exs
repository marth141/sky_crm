import Config

database_url =
  System.fetch_env!("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.fetch_env!("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :web, Web.Endpoint,
  url: [host: "skycrm.live", port: 443],
  https: [
    port: 4001,
    cipher_suite: :strong,
    keyfile: System.get_env("SSL_KEY_PATH"),
    certfile: System.get_env("SSL_CERT_PATH"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true,
  ecto_repos: [Repo]

config :repo, Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE") || "10"),
  ecto_repos: [Repo]

config :emailing, :mailer, adapter: Swoosh.Adapters.Gmail

config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :copper_api,
  copper_api_token: System.fetch_env!("COPPER_TOKEN"),
  copper_api_email: System.fetch_env!("COPPER_EMAIL")

config :goth,
  json: "/app/creds.json" |> File.read!()

config :sighten_api,
  sighten_api_token: System.get_env("SIGHTEN_TOKEN"),
  client_url: "https://engine.goeverbright.com/"

config :hubspot_api,
  hubspot_api_token: System.get_env("HUBSPOT_TOKEN")

config :slack, api_token: System.get_env("SLACK_BOT_TOKEN")

config :sitecapture_api, api_token: System.get_env("SITECAPTURE_TOKEN")

config :pandadoc_api, api_token: System.get_env("PANDADOC_TOKEN")

config :netsuite_api,
  consumer_key: System.get_env("NETSUITE_CONSUMER_KEY"),
  consumer_secret: System.get_env("NETSUITE_CONSUMER_SECRET"),
  token: System.get_env("NETSUITE_API_TOKEN"),
  token_secret: System.get_env("NETSUITE_TOKEN_SECRET"),
  realm: System.get_env("NETSUITE_REALM")

config :onedrive_api,
  client_id: System.get_env("MICROSOFT_CLIENT_ID"),
  client_secret: System.get_env("MICROSOFT_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
