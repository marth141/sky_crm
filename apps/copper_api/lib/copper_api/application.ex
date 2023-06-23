defmodule CopperApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @doc """
  Author(s): Nathan Casados (marth141 @ github)

  Generally this has only been filled with collectors.

  Because of trouble with Copper before, probably only keep these ones uncommented...

  ActivityType, CustomFields, Pipelines, and CustomerSource

  The status server is only good if ever running Opportunities, Tasks, Leads, or People.

  Don't run them in prod.

  Don't run them if they're configured to refresh every 10 minutes.
  """
  def start(_type, _args) do
    children = [
      # {CopperApi.StatusServer, []},
      # {CopperApi.Tasks, []},
      # {CopperApi.LegacyTasks, []},
      # {CopperApi.Leads, []},
      # {CopperApi.LegacyLeads, []},
      # {CopperApi.Opportunities, []},
      # {CopperApi.LegacyOpportunities, []},
      # {CopperApi.Users, []},
      # {CopperApi.ActivityType, []},
      # {CopperApi.Activity, []},
      # {CopperApi.LegacyActivity, []},
      # {CopperApi.CustomFields, []},
      # {CopperApi.Pipelines, []},
      # {CopperApi.CustomerSource, []},
      # {CopperApi.People, []},
      # {Finch, name: CopperFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CopperApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
