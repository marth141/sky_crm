defmodule SkylineOperations.Jobs.HandleHubspotTicket do
  use Oban.Worker, queue: :skyline_operations

  @doc """
  Used to take an incoming Hubspot ticket and create a linked Netsuite case
  """
  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"objectId" => hubspot_ticket_id} = incoming_case,
        id: oban_job_id,
        attempt: attempt
      }) do
    IO.inspect(incoming_case, label: "incoming case", limit: :infinity)

    with {:ok, related_contacts_resp} <-
           force_fetch_contact_associations(hubspot_ticket_id)
           |> IO.inspect(label: "fetch contact associations to ticket"),
         {:ok, related_deals_resp} <-
           force_fetch_deal_associations_to_ticket(hubspot_ticket_id)
           |> IO.inspect(label: "fetch deal associations to ticket"),
         related_contact_id_from_ticket <-
           ((related_contacts_resp["results"] |> List.first())["to"] |> List.first())["id"]
           |> IO.inspect(label: "related contact id from ticket"),
         {:ok, related_deals_by_contact} <-
           force_fetch_deal_associations_to_contact(related_contact_id_from_ticket)
           |> IO.inspect(label: "related deals by contact"),
         related_deal_id_from_ticket <-
           ((related_deals_resp["results"] |> List.first())["to"] |> List.first())["id"]
           |> IO.inspect(label: "related deal id from ticket"),
         related_deal_id_from_contact <-
           ((related_deals_by_contact["results"] |> List.first())["to"] |> List.first())["id"]
           |> IO.inspect(label: "related deal id from contact"),
         %NetsuiteApi.Project{} = related_netsuite_project <-
           repo_get_netsuite_project(related_deal_id_from_ticket, related_deal_id_from_contact)
           |> IO.inspect(label: "Related Netsuite Project"),
         related_hubspot_deal <-
           repo_get_hubspot_deal(related_deal_id_from_ticket, related_deal_id_from_contact)
           |> IO.inspect(label: "Related Hubspot Deal"),
         netsuite_case <-
           %{
             "title" => incoming_case["properties"]["subject"]["value"],
             "priority" =>
               SkylineOperations.CasePriority.name_dictionary()[
                 incoming_case["properties"]["hs_ticket_priority"]["value"]
               ],
             "incomingMessage" => incoming_case["properties"]["content"]["value"],
             "startDate" => TimeApi.mst_now(),
             "status" =>
               SkylineOperations.HubspotTicketPostSaleStageToNetsuiteCaseStatus.hubspot_to_netsuite_dictionary()[
                 incoming_case["properties"]["hs_pipeline_stage"]["value"]
               ],
             "subsidiary" => "1",
             "phone" => related_netsuite_project.custentity_bb_home_owner_phone,
             "company" => related_netsuite_project.netsuite_project_id,
             "customForm" => "219",
             "email" => related_netsuite_project.custentity_bb_home_owner_primary_email,
             "assigned" => related_netsuite_project.custentity_bb_project_manager_employee,
             "profile" => "1",
             "custevent_skl_related_hubspot_contactid" => related_contact_id_from_ticket,
             "custevent_skl_related_hubspot_deal_id" => related_hubspot_deal.hubspot_deal_id,
             "custevent_skl_related_hubspot_ticket_id" => hubspot_ticket_id,
             "quickNote" => incoming_case["properties"]["content"]["value"]
           }
           |> IO.inspect(label: "Input to case"),
         {:ok, _result} <-
           create_support_case(netsuite_case)
           |> IO.inspect(label: "Netsuite create case response") do
      {:ok, netsuite_case}
      |> IO.inspect()
    else
      error ->
        if attempt >= 7 do
          SkylineSlack.send_nate_a_message("""
          *Unknown error while creating Hubspot Ticket as Netsuite Case*
          https://app.hubspot.com/contacts/org/ticket/#{hubspot_ticket_id}

          retry at
          https://skycrm.live/a/skyline_oban/live/#{oban_job_id}

          error: #{Kernel.inspect(error)}
          """)

          SkylineSlack.send_skycrm_helpdesk_message("""
          *Unknown error while creating Hubspot Ticket as Netsuite Case*
          https://app.hubspot.com/contacts/org/ticket/#{hubspot_ticket_id}

          retry at
          https://skycrm.live/a/skyline_oban/live/#{oban_job_id}

          This has been sent to Nate as well.

          Recommended action is to turn off ticket creation workflow in hubspot.

          error: #{Kernel.inspect(error)}
          """)

          {:error, error}
          |> IO.inspect()
        else
          {:error, error}
        end
    end
  end

  defp create_support_case(netsuite_case) do
    NetsuiteApi.create_support_case(netsuite_case)
  end

  defp repo_get_netsuite_project(related_deal_id, related_deal_id_by_contact) do
    related_deal_id
    |> (fn
          nil ->
            %NetsuiteApi.Project{} =
              Repo.get_by!(NetsuiteApi.Project,
                custentity_skl_hs_dealid: related_deal_id_by_contact
              )

          _ ->
            %NetsuiteApi.Project{} =
              Repo.get_by!(NetsuiteApi.Project,
                custentity_skl_hs_dealid: related_deal_id
              )
        end).()
  end

  defp repo_get_hubspot_deal(related_deal_id, related_deal_id_by_contact) do
    related_deal_id
    |> (fn
          nil ->
            %HubspotApi.Deal{} =
              Repo.get_by!(HubspotApi.Deal,
                hubspot_deal_id: related_deal_id_by_contact
              )

          _ ->
            %HubspotApi.Deal{} =
              Repo.get_by!(HubspotApi.Deal,
                hubspot_deal_id: related_deal_id
              )
        end).()
  end

  defp force_fetch_contact_associations(hubspot_ticket_id) do
    with {:ok, %{status: 200, body: body}} <-
           HubspotApi.fetch_association_ticket_to_contact(hubspot_ticket_id) do
      {:ok, body}
    else
      {:ok, %{status: 207}} -> {:ok, nil}
      {:ok, %{status: 429}} -> force_fetch_contact_associations(hubspot_ticket_id)
      error -> {:error, error} |> IO.inspect()
    end
  end

  defp force_fetch_deal_associations_to_ticket(hubspot_ticket_id) do
    with {:ok, %{status: 200, body: body}} <-
           HubspotApi.fetch_association_ticket_to_deal(hubspot_ticket_id) do
      {:ok, body}
      |> IO.inspect(label: "related deals from ticket")
    else
      {:ok, %{status: 207}} -> {:ok, %{"results" => [%{"to" => [%{"id" => nil}]}]}}
      {:ok, %{status: 429}} -> force_fetch_deal_associations_to_ticket(hubspot_ticket_id)
      error -> {:error, error} |> IO.inspect()
    end
  end

  defp force_fetch_deal_associations_to_contact(hubspot_contact_id) do
    with {:ok, %{status: 200, body: body}} <-
           HubspotApi.fetch_association_contact_to_deal(hubspot_contact_id) do
      {:ok, body}
      |> IO.inspect(label: "related deals from contacts")
    else
      {:ok, %{status: 207}} -> {:ok, %{"results" => [%{"to" => [%{"id" => nil}]}]}}
      {:ok, %{status: 429}} -> force_fetch_deal_associations_to_contact(hubspot_contact_id)
      error -> {:error, error} |> IO.inspect()
    end
  end
end
