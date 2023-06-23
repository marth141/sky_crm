defmodule SkylineProposals do
  @moduledoc """
  Documentation for `SkylineProposals`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SkylineProposals.hello()
      :world

  """
  def hello do
    :world
  end

  def get_a_deals_sighten_info(deal_id) do
    properties = fn ->
      [
        "sighten_site_id",
        "street_address",
        "city",
        "state_region",
        "zip",
        "country",
        "email",
        "first_name",
        "last_name",
        "phone_number",
        "sales_area",
        "hubspot_owner_id"
      ]
      |> build_properties_list(:encode_comma)
    end

    {:ok, resp} =
      HubspotApi.Client.get("crm/v3/objects/deals/#{deal_id}?properties=#{properties.()}")

    {:ok, HubspotApi.Deal.new(resp.body)}
  end

  def search_deals_for_site_id(sighten_site_id) do
    with {:ok, %{body: %{"results" => _results, "total" => total}, status: 200} = resp} <-
           HubspotApi.Client.post(
             "crm/v3/objects/deals/search?",
             %{
               "filterGroups" => [
                 %{
                   "filters" => [
                     %{
                       "propertyName" => "sighten_site_id",
                       "operator" => "EQ",
                       "value" => sighten_site_id
                     }
                   ]
                 }
               ]
             }
           ) do
      case total > 0 do
        true ->
          {:ok,
           resp.body
           |> HubspotApi.DealList.new()}

        false ->
          {:error, "Could not find deal with site id"}
      end
    else
      error -> {:error, error}
    end
  end

  def get_a_deals_skysupport_calendar_info(deal_id) do
    properties = fn ->
      [
        "first_name",
        "last_name",
        "email",
        "street_address",
        "city",
        "state_region",
        "country",
        "zip",
        "phone_number",
        "hubspot_owner_id"
      ]
      |> build_properties_list(:encode_comma)
    end

    {:ok, resp} =
      HubspotApi.Client.get("crm/v3/objects/deals/#{deal_id}?properties=#{properties.()}")

    {:ok, HubspotApi.Deal.new(resp.body)}
  end

  def find_all_solar_consultation_engagements_for_deal(nil) do
    {:error, "No deal id given for find_all_solar_consultation_engagements_for_deal"}
  end

  def find_all_solar_consultation_engagements_for_deal(deal_id) do
    {:ok,
     HubspotApi.fetch_all_associate_engagement_details_for_deal(deal_id)
     |> Enum.filter(fn %HubspotApi.EngagementRecord{engagement: engagement} ->
       unless engagement["activityType"] == nil,
         do: String.match?(engagement["activityType"], ~r/Solar Consultation/),
         else: false
     end)}
  end

  def handle_sighten_contract_status_change(received_body_params) do
    with {:ok, oban_job} <-
           SkylineProposals.Jobs.HandleSightenContractStatusChange.new(received_body_params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def oban_drain_proposals_webhooks_queue_with_scheduled_with_recursion() do
    Oban.drain_queue(queue: :skyline_proposals, with_scheduled: true, with_recursion: true)
  end

  def update_hubspot_with_sighten_proposal_info(received_body_params) do
    with {:ok, oban_job} <-
           SkylineProposals.Jobs.UpdateHubspotWithSightenProposalInfo.new(received_body_params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def send_rep_contract_signed_message(received_body_params) do
    with {:ok, oban_job} <-
           SkylineProposals.Jobs.SendRepContractSignedMessage.new(received_body_params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def create_skysupport_solar_consultation_calendar_event_from_hubspot_deal(received_body_params) do
    with {:ok, oban_job} <-
           SkylineProposals.Jobs.CreateSkySupportSolarConsultationCalendarEventFromHubspotDeal.new(
             received_body_params
           )
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def backup_sighten_info_to_hubspot_with_proposals(received_body_params) do
    with {:ok, oban_job} <-
           SkylineProposals.Jobs.BackupSightenInfoToHubspotWithProposals.new(received_body_params)
           |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, msg} -> {:error, msg}
    end
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
