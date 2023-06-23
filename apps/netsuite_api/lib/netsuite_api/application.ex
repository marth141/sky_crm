defmodule NetsuiteApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: NetsuiteApi.Worker.start_link(arg)
      # {NetsuiteApi.Worker, arg}
      # {NetsuiteApi.AuthorityHandlingJurisdictionCollector, []},
      # {NetsuiteApi.CaseCollector, []},
      # {NetsuiteApi.CustomerCollector, []},
      # {NetsuiteApi.EmployeeCollector, []},
      # {NetsuiteApi.LeadSourceCollector, []},
      # {NetsuiteApi.LocationsCollector, []},
      # {NetsuiteApi.ProjectCollector, []},
      # {NetsuiteApi.SalesAddersCollector, []},
      # {NetsuiteApi.SalesPromisesCollector, []},
      # {NetsuiteApi.StateCollector, []},
      # {NetsuiteApi.UtilityCompanyCollector, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NetsuiteApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
