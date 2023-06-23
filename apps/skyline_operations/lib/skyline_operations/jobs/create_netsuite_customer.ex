defmodule SkylineOperations.Jobs.CreateNetsuiteCustomer do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ Github)

  This module is for being able to take a Hubspot Deal and migrate it into a
  Netsuite Customer.

  From there, Netsuite should handle aspects about the record.

  SkyCRM will take the new Netsuite record's id and add it to the Hubspot
  contact.

  At a later time, SkyCRM should check the record for any associated projects
  and take that id and associate it to the Hubspot deal.
  """
  use Oban.Worker, queue: :skyline_operations

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params, id: oban_job_id, attempt: attempt}) do
    with deal_id <- received_body_params["objectId"],
         {:ok, hubspot_properties} <-
           SkylineOperations.get_hubspot_properties_for_netsuite(deal_id)
           |> IO.inspect(label: "GET HUBSPOT PROPERTIES"),
         netsuite_input <-
           hubspot_properties.properties
           |> SkylineOperations.MigrateHubspotDealToNetsuiteCustomer.exec()
           |> IO.inspect(label: "NETSUITE INPUT"),
         # Might inspect this if there are issues
         # Make sure state and utility company state are matching
         {:ok, %Tesla.Env{status: 204, headers: headers}} <-
           NetsuiteApi.Client.post("/customer", netsuite_input)
           |> IO.inspect(label: "NETSUITE RESPONSE"),
         url <-
           Enum.find_value(headers, fn {header, value} ->
             if header == "location", do: value, else: nil
           end)
           |> IO.inspect(label: "NETSUITE URL"),
         created_netsuite_id <-
           String.split(url, "/")
           |> List.last()
           |> IO.inspect(label: "CREATED NETSUITE ID") do
      IO.inspect("Created #{created_netsuite_id}")

      SkylineOperations.Jobs.UpdateHubspotWithNetsuiteCustomerId.new(%{
        "objectId" => deal_id,
        "netsuite_customer_id" => created_netsuite_id
      })
      |> Oban.insert()

      {:ok, "Created Netsuite Customer #{created_netsuite_id}"}
    else
      {:ok, %Tesla.Env{status: 400, body: body}} ->
        body = body |> Jason.decode!()
        error = body["o:errorDetails"] |> List.first() |> IO.inspect()

        cond do
          String.match?(
            error["detail"],
            ~r/Error while accessing a resource. You have entered an Invalid Field Value.+for the following field: custentity_bb_utility_company./
          ) and attempt >= 10 ->
            SkylineSlack.send_skycrm_helpdesk_message("""
            *Known SkyCRM Error While Creating Netsuite Customer*
            https://app.hubspot.com/contacts/org/deal/#{received_body_params["objectId"]}

            This record has an issue where the Utility Company does not exist in the State Specified.
            e.g. State = CO, Utility Company = Xcel Energy (WI)

            To fix, please update the state and utility company to match.
            e.g. State = CO, Utility Company = Xcel Energy (CO)

            retry job at
            https://skycrm.live/a/skyline_oban/live/#{oban_job_id}
            """)

            {:error,
             """
             Utility Company entry issue. Please check the utility company and the state. Make sure the state is present on the Hubspot and that the Utility Company belongs in that state.
             """}

          String.match?(
            error["detail"],
            ~r/Error while accessing a resource. You have entered an Invalid Field Value.+for the following field: custentity_bb_home_owner_primary_email./
          ) and attempt >= 5 ->
            SkylineSlack.send_skycrm_helpdesk_message("""
            *Known SkyCRM Error While Creating Netsuite Customer*
            https://app.hubspot.com/contacts/org/deal/#{received_body_params["objectId"]}

            The record has an invalid email address.
            e.g. email = example@org, example2@org (Too many email addresses)

            e.g. email = example@ (Not a properly formatted email address, missing .com or some other domain)

            To fix, please update the email with a properly formatted email or remove and keep only the primary email address.
            e.g. example@org

            retry job at
            https://skycrm.live/a/skyline_oban/live/#{oban_job_id}
            """)

            {:error,
             """
             Email address is invalid
             """}

          true ->
            {:error, error["detail"]}
        end

      error ->
        {:error, error}
    end
  end
end
