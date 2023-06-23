defmodule SkylineOperations.Jobs.UpdateNetsuiteCustomer do
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
  def perform(%Oban.Job{args: received_body_params}) do
    with deal_id <- received_body_params["objectId"],
         {:ok, hubspot_properties} <-
           SkylineOperations.get_hubspot_properties_for_netsuite(deal_id),
         netsuite_input <-
           hubspot_properties.properties
           |> SkylineOperations.MigrateHubspotDealToNetsuiteCustomer.exec(),
         {:ok, %{status: 204, headers: headers}} <-
           NetsuiteApi.Client.patch(
             "/job/#{hubspot_properties.properties["netsuite_project_id"]}",
             netsuite_input
           ),
         url <-
           Enum.find_value(headers, fn {header, value} ->
             if header == "location", do: value, else: nil
           end),
         created_netsuite_id <-
           String.split(url, "/")
           |> List.last(),
         {:ok, %{id: contact_id}} <- HubspotApi.get_a_deals_associated_contact(deal_id),
         {:ok, _updated_contact_with_netsuite_id_response} <-
           HubspotApi.update_contact(contact_id, %{"netsuite_customer_id" => created_netsuite_id}) do
      IO.inspect("Created #{created_netsuite_id}")
      {:ok, "Created Netsuite Customer #{created_netsuite_id}"}
    else
      {:ok, %{status: 400, body: body}} ->
        body = body |> Jason.decode!()
        error = body["o:errorDetails"] |> List.first()

        if error["detail"]
           |> String.match?(
             ~r/Error while accessing a resource. You have entered an Invalid Field Value.+for the following field: custentity_bb_utility_company./
           ) do
          {:error,
           """
           Utility Company entry issue. Please check the utility company and the state. Make sure the state is present on the Hubspot and that the Utility Company belongs in that state.
           """}
        end

      e ->
        {:error, e}
    end
  end
end
