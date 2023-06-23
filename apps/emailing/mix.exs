defmodule Emailing.MixProject do
  use Mix.Project

  def project do
    [
      app: :emailing,
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
      mod: {Emailing.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mail, "~> 0.2.1"},
      {:swoosh, "~> 1.3.10"},
      # in umbrella
      {:skyline_google, in_umbrella: true}
    ]
  end
end
