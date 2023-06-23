defmodule SkylineGoogle.MixProject do
  use Mix.Project

  def project do
    [
      app: :skyline_google,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SkylineGoogle.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex2ms, "~> 1.0"},
      {:finch, "~> 0.12"},
      {:google_api_admin, "~> 0.33.0"},
      {:google_api_calendar, "~> 0.21.5"},
      {:google_api_sheets, "~> 0.25"},
      {:google_api_drive, "~> 0.25.1"},
      {:goth, "~> 1.3-rc"},
      {:hackney, "~> 1.17.4"},
      {:tesla, "~> 1.4.1"},
      # in umbrella
      {:messaging, in_umbrella: true},
      {:repo, in_umbrella: true}
    ]
  end
end
