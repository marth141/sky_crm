defmodule HubspotApi do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ Github)

  This module contains the highest level of things we would want to do with the
  Hubspot API endpoint. What we want to be able to do with this is to be able to
  build a wrapper around Hubspot. We don't want to include business logic in
  here.

  So when someone says that they want something with a specific field, this app
  should only do stuff like, "Get record(s) with these properties".

  Filter logic and anything else should go into the context of the department
  that is asking for the filter.

  So this should feel almost like an exact copy of Hubspot's API.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HubspotApi.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Sets the `HubspotApi` topic for `:messaging`
  """
  def topic(), do: inspect(__MODULE__)

  @doc """
  Subscribes the process to `HubspotApi`
  """
  def subscribe, do: Messaging.subscribe(topic())

  @doc """
  Publishes a message to the `HubspotApi` subscribers
  """
  def publish(message),
    do: Messaging.publish(topic(), message)

  @doc """
  Unsubscribes the process from `HubspotApi`
  """
  def unsubscribe(),
    do: Messaging.unsubscribe(topic())

  def get_a_contacts_owner(hs_contact_id) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/contacts/#{hs_contact_id}?archived=false&properties=hubspot_owner_id"
           ) do
      body
    else
      {:ok, %{status: 429}} -> get_a_contacts_owner(hs_contact_id)
      error -> {:error, error}
    end
  end

  @doc """
  Starting this with the idea that we can retrieve from Hubspot only the records
  that have been modified this month. This should make for faster job times.
  """
  def search_contacts_modified_this_month(opts \\ []) do
    properties = fetch_all_contact_property_internal_names()

    query_params =
      opts
      |> Enum.filter(fn
        {_atom, value} when is_nil(value) -> false
        {_atom, _value} -> true
      end)

    after_param = query_params |> Keyword.get(:after)

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.post(
             "crm/v3/objects/contacts/search?",
             %{
               "after" => after_param,
               "limit" => 100,
               "properties" => properties,
               "filterGroups" => [
                 %{
                   "filters" => [
                     %{
                       "propertyName" => "lastmodifieddate",
                       "operator" => "BETWEEN",
                       "highValue" => TimeApi.end_of_month() |> TimeApi.to_unix(:millisecond),
                       "value" => TimeApi.start_of_month() |> TimeApi.to_unix(:millisecond)
                     }
                   ]
                 }
               ]
             }
           ) do
      body
      |> HubspotApi.ContactList.new()
    else
      error -> error
    end
  end

  @doc """
  Get Ticket
  """
  def get_ticket(ticket_id) do
    with resp <- HubspotApi.Client.get("crm/v3/objects/tickets/#{ticket_id}?") do
      resp
    else
      error -> {:error, error}
    end
  end

  @spec update_ticket(any, any) :: {:error, any} | {:ok, Tesla.Env.t()}
  @doc """
  Updates a Hubspot Ticket
  """
  def update_ticket(ticket_id, update) do
    with resp <-
           HubspotApi.Client.patch("crm/v3/objects/tickets/#{ticket_id}?", %{
             "properties" => update
           }) do
      resp
    else
      error -> {:error, error}
    end
  end

  @doc """
  Fetches deals related to a ticket from Hubspot
  """
  def fetch_association_ticket_to_deal(ticket_id) do
    with resp <-
           HubspotApi.Client.post(
             "crm/v3/associations/ticket/deal/batch/read?",
             %{"inputs" => [%{"id" => ticket_id}]}
           ) do
      resp
    else
      error -> {:error, error}
    end
  end

  @doc """
  Fetches the deals associated to a contact
  """
  def fetch_association_contact_to_deal(contact_id) do
    with resp <-
           HubspotApi.Client.post(
             "crm/v3/associations/contact/deal/batch/read?",
             %{"inputs" => [%{"id" => contact_id}]}
           ) do
      resp
    else
      error -> {:error, error}
    end
  end

  @doc """
  Fetches contacts related to a ticket from Hubspot
  """
  def fetch_association_ticket_to_contact(ticket_id) do
    with resp <-
           HubspotApi.Client.post(
             "crm/v3/associations/ticket/contact/batch/read?",
             %{"inputs" => [%{"id" => ticket_id}]}
           ) do
      resp
    else
      error -> {:error, error}
    end
  end

  @doc """
  This recieves the sales pipeline dictionary from Hubspot
  """
  def fetch_sales_pipeline_dictionary() do
    with {:ok, %{body: body, status: 200}} <- HubspotApi.Client.get("crm/v3/pipelines/deals?") do
      pipeline_parent =
        body["results"]
        |> Enum.find(fn p -> String.match?(p["label"], ~r/Sales/) end)

      pipeline_parent["stages"]
      |> Enum.map(fn s -> {s["id"], s["label"]} end)
      |> List.insert_at(0, {pipeline_parent["id"], pipeline_parent["label"]})
      |> Enum.into(%{})
    else
      error -> error
    end
  end

  @doc """
  This recieves the fulfillment pipeline dictionary from Hubspot
  """
  def fetch_fulfillment_pipeline_dictionary() do
    with {:ok, %{body: body, status: 200}} <- HubspotApi.Client.get("crm/v3/pipelines/deals?") do
      pipeline_parent =
        body["results"]
        |> Enum.find(fn p -> String.match?(p["label"], ~r/Fulfillment/) end)

      pipeline_parent["stages"]
      |> Enum.map(fn s -> {s["id"], s["label"]} end)
      |> List.insert_at(0, {pipeline_parent["id"], pipeline_parent["label"]})
      |> Enum.into(%{})
    else
      error -> error
    end
  end

  @doc """
  This recieves all of the properties of a deal from Hubspot and maps out only the internal names
  """
  def fetch_all_deal_property_internal_names() do
    read_all_deal_properties()["results"] |> Enum.map(fn p -> p["name"] end) |> Enum.sort()
  end

  @doc """
  For getting contact properties by internal names
  """
  def fetch_all_contact_property_internal_names() do
    read_all_contact_properties()["results"] |> Enum.map(fn p -> p["name"] end) |> Enum.sort()
  end

  @doc """
  This gets all the properties from a contact in Hubspot
  """
  def read_all_contact_properties() do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get("crm/v3/properties/contacts?archived=false") do
      body
    else
      {:ok, %{status: 429}} -> read_all_contact_properties()
      error -> error
    end
  end

  @doc """
  This gets all the properties from a deal in Hubspot
  """
  def read_all_deal_properties() do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get("crm/v3/properties/deals?archived=false") do
      body
    else
      {:ok, %{status: 429}} -> read_all_deal_properties()
      error -> error
    end
  end

  def read_deal_property(property) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get("crm/v3/properties/deals/#{property}?archived=false") do
      body
    else
      {:ok, %{status: 429}} -> read_deal_property(property)
      error -> error
    end
  end

  def read_contact_property(property) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get("crm/v3/properties/contacts/#{property}?archived=false") do
      body
    else
      {:ok, %{status: 429}} -> read_deal_property(property)
      error -> error
    end
  end

  @doc """
  Lists deals after a specific deal id
  Used this to debug the hubspot deal collector. It was coming up short.
  """
  def list_deals_after(deal_id) do
    properties = fetch_all_deal_property_internal_names()

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/deals?archived=false&limit=100&after=#{deal_id}&properties=#{Enum.join(properties, ",")}"
           ) do
      body
    else
      error -> error
    end
  end

  @doc """
  Lists 100 owners from Hubspot.

  It's given a uri when the collectors are collecting more

  Returns `%HubspotApi.OwnerList{}`.

  ## Examples

      iex> HubspotApi.list_deals()
      %HubspotApi.OwnerList{}

      iex> HubspotApi.list_deals("https://somehubspotlink")
      %HubspotApi.OwnerList{}

      iex> HubspotApi.list_deals(["property_a", "property_b"])
      %HubspotApi.OwnerList{}

  """
  def list_owners() do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get("crm/v3/owners/?limit=100&archived=false") do
      body
      |> HubspotApi.OwnerList.new()
    else
      error -> error
    end
  end

  def list_owners(uri) when is_binary(uri) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(uri) do
      body
      |> HubspotApi.OwnerList.new()
    else
      error -> error
    end
  end

  @doc """
  Gets a deal by id

  Can be given properties too
  """
  def get_deal(deal_id, properties) do
    properties = fn ->
      properties
      |> build_properties_list(:encode_comma)
    end

    {:ok, resp} =
      HubspotApi.Client.get("crm/v3/objects/deals/#{deal_id}?properties=#{properties.()}")

    {:ok, HubspotApi.Deal.new(resp.body)}
  end

  def get_deal(deal_id) do
    properties = fetch_all_deal_property_internal_names()

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/deals/#{deal_id}/?properties=#{Enum.join(properties, ",")}&archived=false"
           ) do
      body
    else
      error -> error
    end
  end

  @doc """
  Lists 100 deals from Hubspot.

  It's given a uri when the collectors are collecting more

  Can also be given `properties`

  Returns `%HubspotApi.DealList{}`.

  ## Examples

      iex> HubspotApi.list_deals()
      %HubspotApi.DealList{}

      iex> HubspotApi.list_deals("https://somehubspotlink")
      %HubspotApi.DealList{}

      iex> HubspotApi.list_deals(["property_a", "property_b"])
      %HubspotApi.DealList{}

  """
  def list_deals() do
    properties = fetch_all_deal_property_internal_names()

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/deals?limit=100&properties=#{Enum.join(properties, ",")}&archived=false"
           ) do
      body
      |> HubspotApi.DealList.new()
    else
      error -> error
    end
  end

  def list_deals(uri) when is_binary(uri) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(uri) do
      body
      |> HubspotApi.DealList.new()
    else
      error -> error
    end
  end

  def list_deals(properties) when is_list(properties) do
    properties =
      if(properties == [],
        do: fetch_all_deal_property_internal_names(),
        else: properties
      )

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/deals?limit=100&properties=#{Enum.join(properties, ",")}&archived=false"
           ) do
      body
      |> HubspotApi.DealList.new()
    else
      error -> error
    end
  end

  @doc """
  Lists 100 contacts from Hubspot.

  It's given a uri when the collectors are collecting more

  Can also be given properties

  Returns `%HubspotApi.ContactList{}`.

  ## Examples

      iex> HubspotApi.list_contacts()
      %HubspotApi.ContactList{}

      iex> HubspotApi.list_contacts("https://somehubspotlink")
      %HubspotApi.ContactList{}

      iex> HubspotApi.list_contacts(["property_a", "property_b"])
      %HubspotApi.ContactList{}

  """
  def list_contacts() do
    properties = fetch_all_contact_property_internal_names()

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/contacts?limit=100&properties=#{Enum.join(properties, ",")}&archived=false"
           ) do
      body
      |> HubspotApi.ContactList.new()
    else
      error -> error
    end
  end

  def list_contacts(uri) when is_binary(uri) do
    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(uri) do
      body
      |> HubspotApi.ContactList.new()
    else
      error -> error
    end
  end

  def list_contacts(properties) when is_list(properties) do
    properties =
      if(properties == [],
        do: fetch_all_contact_property_internal_names(),
        else: properties
      )

    with {:ok, %{body: body, status: 200}} <-
           HubspotApi.Client.get(
             "crm/v3/objects/contacts?limit=100&properties=#{Enum.join(properties, ",")}&archived=false"
           ) do
      body
      |> HubspotApi.ContactList.new()
    else
      error -> error
    end
  end

  @doc """
  Used to take a deal that was recieved by a Hubspot workflow
  and turn it into a `HubspotApi.Deal` struct
  """
  def to_struct(:received_deal_webhook, nil) do
    {:error, "No data provided for deal"}
  end

  def to_struct(:received_deal_webhook, body_params) when is_map(body_params) do
    {:ok, HubspotApi.Deal.new(body_params)}
  end

  def to_struct(nil) do
    {:error, "No {:hs_obj_type_atom, body_params} passed"}
  end

  @doc """
  Used to search deals with some given search `params`
  """
  def search_deals(params) do
    HubspotApi.Client.post("crm/v3/objects/deals/search?", params)
  end

  @doc """
  Gets all of the contacts associated with a deal.
  """
  def get_a_deals_associated_contacts(deal_id) do
    with {:ok, %{status: 200, body: body}} <-
           HubspotApi.Client.get("crm/v4/objects/deals/#{deal_id}/associations/contacts/?") do
      %{"results" => results} = body

      {:ok,
       results
       |> Enum.find_value(fn %{"toObjectId" => to} ->
         to
       end)}
    else
      {:ok, %{status: 429}} -> get_a_deals_associated_contacts(deal_id)
      error -> {:error, error}
    end
  end

  @doc """
  Updates a Hubspot deal with given parameters in map

  ## Parameters

  *   `deal_id` the hubspot deal to update
  *   `properties` the data to update it with

  """
  @spec update_deal(any, map) :: {:error, any} | {:ok, Tesla.Env.t()}
  def update_deal(deal_id, properties) when is_map(properties) do
    HubspotApi.Client.patch(
      "crm/v3/objects/deals/#{deal_id}?",
      %{
        "properties" => properties
      }
    )
  end

  @doc """
  Updates a hubspot contact with given parameters in map

  ## Parameters

  * `contact_id` the hubspot contact to update
  * `properties` the data to update it with

  """
  def update_contact(contact_id, properties) when is_map(properties) do
    HubspotApi.Client.patch(
      "crm/v3/objects/contacts/#{contact_id}?",
      %{
        "properties" => properties
      }
    )
  end

  @doc """
  Get's a contact by their id
  """
  def get_contact_by_id(contact_id) do
    properties = fn ->
      [
        "createdate",
        "email",
        "firstname",
        "hs_object_id",
        "lastmodifieddate",
        "lastname",
        "hubspot_owner_id"
      ]
      |> Enum.map(fn string -> "%2C" <> string end)
      |> List.to_string()
    end

    with {:ok, %{status: 200} = resp} <-
           HubspotApi.Client.get(
             "crm/v3/objects/contacts/#{contact_id}?properties=#{properties.()}"
           ) do
      {:ok, HubspotApi.Contact.new(resp.body)}
    else
      {:ok, %{status: 429}} -> {:error, "Rate limited"}
    end
  end

  @doc """
  Get's some hubspot owner by id
  """
  def get_owner(owner_id) do
    with {:ok, %{body: body, status: 200}} <- HubspotApi.Client.get("crm/v3/owners/#{owner_id}?") do
      {:ok, HubspotApi.Owner.new(body)}
    else
      error -> {:error, error}
    end
  end

  @doc """
  Used to search deals by emails
  """
  def search_deals_for_email(email) do
    with {:ok, %{status: 200} = resp} <-
           HubspotApi.Client.post(
             "crm/v3/objects/deals/search?",
             %{
               "filterGroups" => [
                 %{
                   "filters" => [
                     %{
                       "propertyName" => "email",
                       "operator" => "EQ",
                       "value" => "#{email}"
                     }
                   ]
                 }
               ]
             }
           ) do
      {:ok,
       resp.body["results"]
       |> Enum.map(fn resp -> HubspotApi.Deal.new(resp) end)}
    else
      error -> error
    end
  end

  @doc """
  Used to get a deals associated contact
  """
  def get_a_deals_associated_contact(nil) do
    {:error, "No deal id given for get_a_deals_associated_contact"}
  end

  def get_a_deals_associated_contact(deal_id) do
    with {:ok, assoc_contact_id} <-
           HubspotApi.get_a_deals_associated_contacts(deal_id),
         {:ok, %HubspotApi.Contact{} = contact} <-
           HubspotApi.get_contact_by_id(assoc_contact_id) do
      {:ok, contact}
    else
      {:error, "Rate limited"} ->
        {:error, "Rate limited"}

      _error ->
        {:error, "Could not find associated contact"}
    end
  end

  @doc """
  Used to get the owner info of a deal
  """
  def get_a_deals_owner_info(nil) do
    {:error, "No Deal ID given for get_a_deals_owner_info"}
  end

  def get_a_deals_owner_info(deal_owner_id) do
    with {:ok, %HubspotApi.Owner{} = owner_info} <-
           HubspotApi.get_owner(deal_owner_id) do
      {:ok, owner_info}
    else
      _error ->
        IO.puts("Could not find deal owner info")
        nil
    end
  end

  @doc """
  Used to get a contact's owner info
  """
  def get_a_contacts_owner_info(nil) do
    {:error, "No contact id given for get_a_contacts_owner_info"}
  end

  def get_a_contacts_owner_info(contact_owner_id) do
    with {:ok, %HubspotApi.Owner{} = owner_info} <-
           HubspotApi.get_owner(contact_owner_id) do
      {:ok, owner_info}
    else
      _error ->
        IO.puts("Could not find contact owner info")
        nil
    end
  end

  @doc """
  Used to get all of the associated engagement ids for a deal
  """
  def fetch_all_associate_engagement_ids_for_deal(nil) do
    {:error, "No deal id given for fetch_all_associate_engagement_ids_for_deal"}
  end

  def fetch_all_associate_engagement_ids_for_deal(deal_id) do
    with {:ok, %{body: %{"results" => results}, status: 200}} <-
           HubspotApi.Client.get("crm/v3/objects/deals/#{deal_id}/associations/engagements?") do
      Enum.map(results, fn result -> HubspotApi.AssociationRecord.new(result) end)
    else
      err -> IO.inspect(err)
    end
  end

  @doc """
  Used to fetch all associate engagement details of a deal
  """
  def fetch_all_associate_engagement_details_for_deal(nil) do
    {:error, "No deal id given for fetch_all_associate_engagement_details"}
  end

  def fetch_all_associate_engagement_details_for_deal(deal_id) do
    fetch_all_associate_engagement_ids_for_deal(deal_id)
    |> Enum.map(fn %HubspotApi.AssociationRecord{id: id} ->
      with {:ok, %{body: body, status: 200}} <-
             HubspotApi.Client.get("engagements/v1/engagements/#{id}?") do
        HubspotApi.EngagementRecord.new(body)
      else
        err -> IO.inspect(err)
      end
    end)
  end

  defp build_properties_list(list_of_properties, :encode_comma) do
    list_of_properties
    |> Enum.map(&percent_encode_property/1)
    |> List.to_string()
  end

  defp percent_encode_property(property) do
    "%2C#{property}"
  end
end
