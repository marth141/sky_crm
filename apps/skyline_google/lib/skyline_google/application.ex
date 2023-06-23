defmodule SkylineGoogle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    credentials =
      case Application.get_env(:skyline_google, :env) do
        :dev ->
          "config/creds.json" |> File.read!() |> Jason.decode!()

        :test ->
          "config/creds.json" |> File.read!() |> Jason.decode!()

        :prod ->
          "/app/creds.json" |> File.read!() |> Jason.decode!()
      end

    scopes = [
      "https://www.googleapis.com/auth/calendar",
      "https://www.googleapis.com/auth/gmail.compose",
      "https://www.googleapis.com/auth/spreadsheets",
      "https://www.googleapis.com/auth/admin.directory.user"
    ]

    source = {:service_account, credentials, scopes: scopes}

    children = [
      {Goth, name: SkylineGoogle.Goth, source: source},
      {SkylineGoogle.Users.Collector, []},
      {Finch, name: SkylineGoogleFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SkylineGoogle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
