defmodule SkylineOperations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: SkylineOperations.Worker.start_link(arg)
      # {SkylineOperations.Worker, arg}
      # {SkylineOperations.SalesRepUpdater, []},
      # {SkylineOperations.NetsuiteStatusGenserver2ElectricBoogaloo, []},
      {SkylineOperations.NetsuiteTicketStatusGenserver, []},
      {SkylineOperations.NMADocumentSender, []}
      # {SkylineOperations.MapGenserver, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SkylineOperations.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
