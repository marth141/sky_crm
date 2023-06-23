defmodule SkylineProposals.Jobs.SendRepContractSignedMessage do
  use Oban.Worker, queue: :skyline_sales

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params, id: oban_job_id, attempt: attempt}) do
    # From the site id, find the deal and its energy consultant
    with site_id <- received_body_params["site"],
         {:ok, %HubspotApi.DealList{results: results}} <-
           SkylineProposals.search_deals_for_site_id(site_id),
         %HubspotApi.Deal{} = first_hubspot_result <- results |> List.first(),
         hubspot_deal_id <- first_hubspot_result.hubspot_deal_id,
         {:ok, hubspot_properties} <-
           HubspotApi.get_deal(hubspot_deal_id, [
             "hubspot_owner_id",
             "first_name",
             "last_name"
           ]),
         energy_consultant_id <- hubspot_properties.properties["hubspot_owner_id"],
         customer_first_name <- hubspot_properties.properties["first_name"],
         customer_last_name <- hubspot_properties.properties["last_name"],
         {:ok, energy_consultant} <- HubspotApi.get_a_deals_owner_info(energy_consultant_id) do
      # Send Message to Energy Consultant on contract sign
      SkylineSlack.send_message_to_user_email(energy_consultant.email, """
      🎉 The Customer #{customer_first_name} #{customer_last_name} has signed their contract! 🎉
      🎉 Thank you so much! 🎉
      """)

      SkylineSlack.send_message_to_user_email("salessupport@org", """
      🎉 The Customer #{customer_first_name} #{customer_last_name} has signed their contract! 🎉
      🎉 Thank you so much! 🎉
      """)

      {:ok, "Message sent"}
    else
      {:error, "Could not find deal with site id"} = error ->
        if attempt >= 10 do
          %SightenApi.Schemas.Site{contacts: contacts} =
            SightenApi.fetch_site_by_id(received_body_params["site"])

          %SightenApi.Schemas.Site.Contact{first_name: f_name, last_name: l_name} =
            List.first(contacts)

          SkylineSlack.send_skycrm_helpdesk_message("""
          *Known SkyCRM error occured while sending rep contract signed message*
          https://engine.goeverbright.com/address/#{received_body_params["site"]}

          To fix, please visit the goeverbirght link above for #{f_name} #{l_name}.

          Then find the customer with that name in Hubspot and copy "#{received_body_params["site"]}" to the "sighten site id" field on the hubspot deal.

          retry job at
          https://skycrm.live/a/skyline_oban/live/#{oban_job_id}
          """)

          SkylineSlack.send_message_to_user_email("salessupport@org", """
          Hello there,

          It looks like #{f_name} #{l_name} has signed their contract and the EverBright was created manually and the EverBright ID was forgotten.

          This message was produced while trying to send the rep a message that the customer has signed their contract and was broken because of the manual creation and forgotten ID.

          Please copy "#{received_body_params["site"]}" onto #{f_name} #{l_name}'s Hubspot Deal under the "Sighten ID" property.

          This will prevent any further automation errors from happening for this record.

          When ready to retry, please ask Jason

          Thanks!
          """)

          SkylineSlack.send_message_to_user_email("jason@org", """
          Hello there,

          It looks like #{f_name} #{l_name} has signed their contract and the EverBright was created manually and the EverBright ID was forgotten.

          This message was produced while trying to send the rep a message that the customer has signed their contract and was broken because of the manual creation and forgotten ID.

          Please copy "#{received_body_params["site"]}" onto #{f_name} #{l_name}'s Hubspot Deal under the "Sighten ID" property.

          This will prevent any further automation errors from happening for this record.

          Retry at https://skycrm.live/a/skyline_oban/live/#{oban_job_id}

          Thanks!
          """)

          error
        else
          error
        end

      e ->
        e
    end
  end
end
