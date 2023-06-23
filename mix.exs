defmodule SkyCRM.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      version: "0.6.30",
      elixir: "~> 1.12",
      releases: [
        sky_crm: [
          applications: [
            copper_api: :permanent,
            emailing: :permanent,
            hubspot_api: :permanent,
            identity: :permanent,
            info_tech: :permanent,
            kixie_api: :permanent,
            messaging: :permanent,
            repo: :permanent,
            sighten_api: :permanent,
            sitecapture_api: :permanent,
            skyline_employee_manager: :permanent,
            skyline_google: :permanent,
            netsuite_api: :permanent,
            netsuite_oauth: :permanent,
            onedrive_api: :permanent,
            pandadoc_api: :permanent,
            skyline_oban: :permanent,
            skyline_operations: :permanent,
            skyline_proposals: :permanent,
            skyline_sales: :permanent,
            skyline_slack: :permanent,
            time_api: :permanent,
            web: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    []
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run apps/repo/priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "tailwind default --minify",
        "cmd --app web --cd assets npm run deploy",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end
