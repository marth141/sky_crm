defmodule SkylineOperations.NetsuiteTicketStatusGenserver do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This GenServer in theory should...

  1. Get all of the tickets from the Netsuite Case/Hubspot Ticket table
  2. From the cases in this table, get their hubspot ticket number
  3. Using the hubspot ticket number, update the hubspot ticket with
     netsuite status

  """
  use GenServer
  import Ecto.Query

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    case Application.get_env(:skyline_operations, :env) do
      :dev ->
        {:ok, %{last_refresh: nil}}

      :test ->
        {:ok, %{last_refresh: nil}}

      :prod ->
        NetsuiteApi.subscribe()
        {:ok, %{last_refresh: nil}}
    end
  end

  def handle_info(:netsuite_projects_updated, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def refresh_cache() do
    get_all_tickets()
    |> Task.async_stream(&force_update_hubspot_ticket/1, timeout: :infinity)
    |> Enum.to_list()

    IO.puts("\n \n ======= Netsuite Status Refreshed ======= \n \n")
    :ok
  end

  defp force_update_hubspot_ticket(ticket) do
    with {:ok, %{status: 200}} <-
           HubspotApi.update_ticket(ticket.custevent_skl_related_hubspot_ticket_id, %{
             "hs_pipeline_stage" =>
               SkylineOperations.HubspotTicketPostSaleStageToNetsuiteCaseStatus.netsuite_to_hubspot_dictionary()[
                 ticket.status
               ],
             "netsuite_case_id" => ticket.netsuite_case_id
           }) do
      :ok
    else
      {:ok, %{status: 429}} ->
        force_update_hubspot_ticket(ticket)

      {:ok, %{status: 404}} ->
        SkylineSlack.send_skycrm_helpdesk_message("""
        *Known SkyCRM Issue*
        https://org.app.netsuite.com/app/crm/support/supportcase.nl?id=#{ticket.netsuite_case_id}

        This case does not have an existing Hubspot Ticket, as far as SkyCRM can tell.

        If a hubspot ticket does exit, under "custom" please fill in the "Hubspot Ticket ID" field with the huspot ticket id.

        This message does not have a retry link.
        """)

        {:ok, "sent slack message"}

      error ->
        {:error, error}
    end
  end

  def get_all_tickets() do
    Repo.all(
      from(c in NetsuiteApi.Case,
        where: not is_nil(c.custevent_skl_related_hubspot_ticket_id),
        order_by: [desc: c.netsuite_case_id]
      )
    )
  end

  def get_one_ticket() do
    Repo.all(from(c in NetsuiteApi.Case, where: c.netsuite_case_id == 68788))
  end
end
