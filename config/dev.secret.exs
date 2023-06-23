import Config

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :onedrive_api,
  client_id: System.get_env("MICROSOFT_CLIENT_ID"),
  client_secret: System.get_env("MICROSOFT_CLIENT_SECRET")

config :netsuite_api,
  consumer_key: System.get_env("NETSUITE_CONSUMER_KEY"),
  consumer_secret: System.get_env("NETSUITE_CONSUMER_SECRET"),
  token: System.get_env("NETSUITE_SB_TOKEN_ID"),
  token_secret: System.get_env("NETSUITE_SB_TOKEN_SECRET"),
  realm: System.get_env("NETSUITE_SB_REALM")
