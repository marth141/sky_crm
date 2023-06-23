defmodule SkylineSales.Jobs.CreateSightenSite do
  use Oban.Worker, queue: :skyline_proposals

  # Edit: On the 5th attempt, send a message to Setter to verify information on deal

  @impl Oban.Worker
  def perform(%Oban.Job{args: body_params, attempt: attempt}) do
    with {:ok, %HubspotApi.Deal{hubspot_deal_id: received_deal_id}} <-
           HubspotApi.to_struct(:received_deal_webhook, body_params)
           |> IO.inspect(label: "TO STRUCT"),
         {:ok, %HubspotApi.Contact{} = contact_info} <-
           HubspotApi.get_a_deals_associated_contact(received_deal_id)
           |> IO.inspect(label: "ASSOCIATED CONTACT"),
         {:ok, %HubspotApi.Deal{} = deal_sighten_info} <-
           SkylineSales.get_a_deals_sighten_info(received_deal_id)
           |> IO.inspect(label: "GET SIGHTEN INFO"),
         {:ok, %HubspotApi.Owner{} = deal_contact_owner_info} <-
           HubspotApi.get_owner(contact_info.properties["hubspot_owner_id"])
           |> IO.inspect(label: "GET CONTACT OWNER DETAILS"),
         {:ok, %HubspotApi.Owner{} = deal_owner_info} <-
           HubspotApi.get_owner(deal_sighten_info.properties["hubspot_owner_id"] |> IO.inspect())
           |> IO.inspect(label: "GET DEAL OWNER DETAILS"),
         {:ok, missing_properties} <-
           SkylineSales.find_missing_create_sighten_site_properties(
             deal_sighten_info.properties,
             deal_contact_owner_info,
             deal_owner_info
           )
           |> IO.inspect(label: "MISSING PROPERTIES"),
         {:ok, create_site_request} <-
           SightenApi.cast_as_sighten_site_request(deal_sighten_info.properties)
           |> IO.inspect(label: "CREATE SITE REQUEST") do
      missing_props_values = Map.values(missing_properties)

      if Enum.any?(missing_props_values, fn value -> String.match?(value, ~r/❌/) end) do
        SkylineSales.send_missing_properties_msg_via_slack(deal_sighten_info, missing_properties)
      end

      case {is_nil(deal_sighten_info.properties["sighten_site_id"]) or
              deal_sighten_info.properties["sighten_site_id"] == ""} do
        {true} ->
          with {:ok, %{body: %{"uuid" => created_sighten_site_id}, status: status}}
               when status in 200..299 <-
                 SightenApi.create_site_in_sighten(create_site_request),
               {:ok, _association_response} <-
                 SkylineSales.associate_sighten_site_with_hubspot_deal(
                   received_deal_id,
                   created_sighten_site_id
                 ) do
            {:ok,
             """
             Created Sighten site and associated with Hubspot Deal
             #{created_sighten_site_id}
             ▼▲
             #{received_deal_id}
             """}
          else
            {:error, error} ->
              IO.puts("Something when wrong trying to create sighten site.")
              IO.puts(JSON.encode!(error))
              {:error, error}

            {:ok, error} ->
              IO.puts("Unable to create sighten site due ot missing information")
              IO.puts(error)

              if attempt >= 7 do
                SkylineSlack.send_message_to_user_email("salessupport@org", """
                SkyCRM could not create GoEverBright (Sighten) Site

                Affects: https://app.hubspot.com/contacts/org/deal/#{body_params["objectId"]}

                Reason: The deal is missing information.

                Missing: Address, Phone Number, Customer Name, Email, Contact Owner, Deal Owner, or Sales Area

                Fix: Please have the rep fill in information or delete the record if it's not needed.
                """)
              else
                error
              end

              {:error, "Unable to create sighten site due ot missing information"}
          end

        {false} ->
          msg =
            "Deal #{deal_sighten_info.hubspot_deal_id} already has Sighten site #{deal_sighten_info.properties["sighten_site_id"]} added"

          IO.puts(msg)

          {:ok, msg}
      end
    else
      {:error, "Could not find associated contact"} = error ->
        if attempt >= 10 do
          SkylineSlack.send_message_to_user_email("salessupport@org", """
          SkyCRM could not create GoEverBright (Sighten) Site

          Affects: https://app.hubspot.com/contacts/org/deal/#{body_params["objectId"]}

          Reason: The contact owner is not listed

          Fix: Please assign a contact owner to the customer's contact.
          """)
        else
          error
        end

      error ->
        {:error, error}
    end
  end
end
