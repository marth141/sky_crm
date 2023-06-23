defmodule SkylineOperations.Jobs.UpdateHubspotWithNetsuiteCustomerId do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ Github)

  This module is for updating a hubspot record with the netsuite customer id
  """
  use Oban.Worker, queue: :long_updater

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    do_it(received_body_params)
  end

  def do_it(received_body_params) do
    with deal_id <- received_body_params["objectId"],
         created_netsuite_id <- received_body_params["netsuite_customer_id"],
         {:ok, %{id: contact_id}} <- HubspotApi.get_a_deals_associated_contact(deal_id),
         {:ok, _updated_contact_with_netsuite_id_response} <-
           HubspotApi.update_contact(contact_id, %{"netsuite_customer_id" => created_netsuite_id}) do
      IO.inspect("Updated hubspot contact #{contact_id} with #{created_netsuite_id}")
      {:ok, "Updated hubspot contact #{contact_id} with #{created_netsuite_id}"}
    else
      {:ok, %{status: 400, body: body}} ->
        {:error, body}

      {:ok, %{status: 429}} ->
        handle_429(received_body_params)

      {:error, "Rate limited"} ->
        handle_429(received_body_params)
    end
  end

  defp handle_429(received_body_params) do
    Process.sleep(60000)
    do_it(received_body_params)
  end
end
