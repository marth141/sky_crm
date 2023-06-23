defmodule Web.HookmonController do
  @moduledoc """
  This thing controls most of what happens with webhooks coming from an external
  service to Org.

  So if something is some automation between Hubspot and GoEverBright (Sighten)
  or Hubspot and Netsuite, this module is where to look.
  """
  use Web, :controller

  @doc """
  Used to test looking at some incoming connection.
  Usually used to explore APIs.
  """
  @doc since: "Mar 25 2022"
  def inspect(conn, params) do
    IO.inspect(conn, limit: :infinity)
    IO.inspect(params, limit: :infinity)
    respond_ok(conn)
  end

  @doc """
  Used to create a netsuite case from an incoming Hubspot Ticket
  """
  @doc since: "Mar 25 2022"
  def handle_hubspot_ticket(conn, params) do
    with {:ok, _job} <- SkylineOperations.handle_hubspot_ticket(params) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while sending ticket to netsuite from hubspot")
        respond_error(conn)
    end
  end

  @doc """
  Sends site survey date from Hubspot to Netsuite when it's known in Hubspot

  source
  OFFICIAL SALES : Site Survey Completed Alert
  https://app.hubspot.com/workflows/org/platform/flow/80273578/edit

  Send Site Survey to Netsuite Webhook (LIVE)
  https://app.hubspot.com/workflows/org/platform/flow/149494922/edit
  """
  @doc since: "Mar 25 2022"
  def send_site_survey_completed_from_hubspot_to_netsuite(conn, params) do
    with {:ok, _job} <-
           SkylineOperations.send_site_survey_completed_from_hubspot_to_netsuite(params) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while Updating Netsuite with Site Survey Completed")
        respond_error(conn)
    end
  end

  def dev_calendar(conn, params) do
    IO.inspect(conn: conn)
    IO.inspect(params: params)
  end

  @doc """
  Used to look at SiteCapture via API
  """
  @doc since: "Mar 25 2022"
  def sitecapture(conn, params) do
    IO.inspect(conn)
    IO.inspect(params, limit: :infinity)
    respond_ok(conn)
  end

  @doc """
  There is a script in Netsuite to go with this where
  you can send nate a message.
  """
  @doc since: "Mar 25 2022"
  def netsuite(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
    # InfoTech.write_to_json(Jason.encode!(params), "netsuite_params")
    # SkylineSlack.send_nate_a_message(Jason.encode!(params))
    respond_ok(conn)
  end

  @doc """
  When a sighten contract changes its status, this starts an Oban Job
  where the job will take sighten info and deliver it to the matching
  hubspot record.

  source
  https://engine.goeverbright.com/settings/integrations/external
  """
  @doc since: "Mar 25 2022"
  def handle_sighten_contract_status_change(conn, params) do
    contract_sub_tasks = params["sub_tasks"] |> List.first()

    if contract_sub_tasks["status"] == "COMP" do
      IO.puts("🙌 Completed Contract! 🙌")
      SkylineProposals.handle_sighten_contract_status_change(params)
      respond_ok(conn)
    else
      respond_ok(conn)
    end
  end

  @doc """
  Sends sales guys a message alerting them when the customer has signed their
  contract

  source
  https://engine.goeverbright.com/settings/integrations/external
  """
  @doc since: "Mar 25 2022"
  def send_rep_contract_signed_message(conn, params) do
    contract_sub_tasks = params["sub_tasks"] |> List.first()

    if contract_sub_tasks["status"] == "COMP" do
      IO.puts("🙌 Completed Contract! 🙌")

      with {:ok, _status} <- SkylineProposals.send_rep_contract_signed_message(conn.body_params) do
        respond_ok(conn)
      else
        {:error, _error} ->
          IO.puts("Error while Sending Contract Signed Message")
          respond_error(conn)
      end
    else
      respond_ok(conn)
    end
  end

  @doc """
  Some point in the sales process, Hubspot will alert SkyCRM that a sighten site
  needs to be created and this will create the sighten site.

  source
  (Official) Deal > Slack > Webhook (Proposal Request Ticket)
  https://app.hubspot.com/workflows/org/platform/flow/134935195/edit

  FUNCTION: Send Deal to Sighten Webhook (LIVE)
  https://app.hubspot.com/workflows/org/platform/flow/74102339/edit
  """
  @doc since: "Mar 25 2022"
  def create_sighten_site_from_hubspot_deal(
        conn,
        _params
      ) do
    with {:ok, _sighten_resp} <-
           SkylineSales.create_sighten_site_from_hubspot_deal(conn.body_params) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while creating Sighten site")
        respond_error(conn)
    end
  end

  @doc """
  Usually adds a calendar event to Sky Supports calendar
  when a solar consultation is happening.

  source
  Sales: Meetings Webhook Workflow
  https://app.hubspot.com/workflows/org/platform/flow/92074801/edit

  FUNCTION: Send Deal to SkySupport Calendar Webhook (LIVE)
  https://app.hubspot.com/workflows/org/platform/flow/85930900/edit
  """
  @doc since: "Mar 25 2022"
  def create_skysupport_calendar_event_from_hubspot_deal(
        conn,
        _params
      ) do
    with {:ok, _copper_deal_resp} <-
           SkylineProposals.create_skysupport_solar_consultation_calendar_event_from_hubspot_deal(
             conn.body_params
           ) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while creating Sky Support Solar Consultation Event")
        respond_error(conn)
    end
  end

  @doc """
  When the sales process is getting ready to transition into fulfillment,
  this function will create a netsuite customer from the hubspot deal.

  source
  Sales: Closed-Won > Fulfillment Workflow > Slack Alert > Netsuite Webhook
  https://app.hubspot.com/workflows/org/platform/flow/74467160/edit

  FUNCTION: Send Deal to Netsuite Webhook (LIVE)
  https://app.hubspot.com/workflows/org/platform/flow/131550854/edit
  """
  @doc since: "Mar 25 2022"
  def create_netsuite_customer_from_hubspot_deal(conn, params) do
    with {:ok, _copper_deal_resp} <-
           SkylineOperations.create_netsuite_customer_from_hubspot_deal(params) do
      respond_ok(conn)
    else
      {:error, _error} ->
        IO.puts("Error while creating Netsuite Customer")
        respond_error(conn)
    end
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end

  defp respond_error(conn) do
    json(conn, %{status: :error})
  end
end
