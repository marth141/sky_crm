defmodule SkylineProposals.Jobs.CreateSkySupportSolarConsultationCalendarEventFromHubspotDeal do
  use Oban.Worker, queue: :skyline_proposals

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    with {:ok, %HubspotApi.Deal{hubspot_deal_id: received_deal_id}} <-
           HubspotApi.to_struct(:received_deal_webhook, received_body_params),
         {:ok, %{hubspot_deal_id: deal_id} = deal_info} <-
           SkylineProposals.get_a_deals_skysupport_calendar_info(received_deal_id),
         {:ok, contact_owner} <- get_a_deals_contact_info(deal_id),
         {:ok, deal_owner} <-
           HubspotApi.get_a_deals_owner_info(deal_info.properties["hubspot_owner_id"]),
         {:ok, solar_consultations} <-
           SkylineProposals.find_all_solar_consultation_engagements_for_deal(deal_id),
         {:ok, calendar_event} <-
           SkylineGoogle.SkySupportCalendarEvent.new(
             deal_info,
             contact_owner,
             deal_owner,
             solar_consultations
           ) do
      IO.puts("Creating Calendar event for SkySupport")
      IO.inspect(calendar_event)
      event = SkylineGoogle.create_skysupport_calendar_event_from_hubspot_deal(calendar_event)
      IO.puts("Calendar invite created")
      {:ok, event}
    else
      {:error, "Missing solar consultations" = msg} ->
        IO.inspect(msg)
        {:ok, msg}

      {:error, err} ->
        IO.inspect(err)
        {:error, err}
    end
  end

  defp get_a_deals_contact_info(deal_id) do
    with {:ok, contact} <- HubspotApi.get_a_deals_associated_contact(deal_id),
         {:ok, contact_owner} <-
           HubspotApi.get_a_contacts_owner_info(contact.properties["hubspot_owner_id"]) do
      {:ok, contact_owner}
    else
      _error ->
        {:error, "Unable to find deal's contact owner email for deal #{deal_id}"}
    end
  end
end
