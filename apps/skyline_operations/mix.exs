defmodule SkylineOperations.MixProject do
  use Mix.Project

  def project do
    [
      app: :skyline_operations,
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
      mod: {SkylineOperations.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:ecto, "~> 3.4"},
      {:json, "1.4.1"},
      {:geocoder, "~> 1.1"},
      # in umbrella
      {:copper_api, in_umbrella: true},
      {:emailing, in_umbrella: true},
      {:hubspot_api, in_umbrella: true},
      {:netsuite_api, in_umbrella: true},
      {:onedrive_api, in_umbrella: true},
      {:pandadoc_api, in_umbrella: true},
      {:sighten_api, in_umbrella: true},
      {:skyline_oban, in_umbrella: true},
      {:skyline_slack, in_umbrella: true},
      {:time_api, in_umbrella: true}
    ]
  end
end
