defmodule CopperApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :copper_api,
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
      mod: {CopperApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:date_time_parser, "~> 1.1.1"},
      {:ecto, "~> 3.4"},
      {:ex2ms, "~> 1.0"},
      {:finch, "~> 0.12"},
      {:hackney, "~> 1.17.4"},
      {:tesla, "~> 1.4.1"},
      {:timex, "~> 3.7.5"},
      # in umbrella
      {:messaging, in_umbrella: true},
      {:repo, in_umbrella: true},
      {:time_api, in_umbrella: true}
    ]
  end
end
