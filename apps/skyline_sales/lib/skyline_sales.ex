defmodule SkylineSales do
  @moduledoc """
  Documentation for `SkylineSales`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SkylineSales.hello()
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
        "hubspot_owner_id",
        "contact_owner"
      ]
      |> build_properties_list(:encode_comma)
    end

    {:ok, resp} =
      HubspotApi.Client.get("crm/v3/objects/deals/#{deal_id}?properties=#{properties.()}")

    {:ok, HubspotApi.Deal.new(resp.body)}
  end

  def associate_sighten_site_with_hubspot_deal(deal_id, site_id) do
    HubspotApi.Client.patch(
      "crm/v3/objects/deals/#{deal_id}?",
      %{
        "properties" => %{
          "sighten_site_id" => "#{site_id}"
        }
      }
    )
  end

  def create_sighten_site_from_hubspot_deal(received_body_params) do
    with {:ok, oban_job} <-
           SkylineSales.Jobs.CreateSightenSite.new(received_body_params) |> Oban.insert() do
      {:ok, oban_job}
    else
      {:error, _msg} = error -> error
    end
  end

  def send_missing_properties_msg_via_slack(received_deal, missing_properties) do
    with {:ok, oban_job} <-
           SkylineSales.Jobs.SlackMissingSightenProperties.new(%{
             "received_deal" => received_deal |> Map.from_struct() |> Map.delete(:__meta__),
             "missing_properties" => missing_properties
           })
           |> Repo.insert() do
      {:ok, oban_job}
    else
      error ->
        IO.inspect(error)
        error
    end
  end

  def slack_hubspot_helpdesk({:missing_sales_data, object_id, missing_properties}) do
    SkylineSlack.send_message_to_channel(
      "#hubspot_helpdesk",
      SkylineSlack.create_missing_sales_data_message(object_id, missing_properties)
    )
  end

  def send_message_to_user(user_id, message) do
    SkylineSlack.send_message_to_user(user_id, message)
  end

  def find_missing_create_sighten_site_properties(
        properties,
        %HubspotApi.Owner{} = deal_owner,
        %HubspotApi.Owner{} = contact_owner
      ) do
    IO.puts("Finding missing sighten properties")

    {
      :ok,
      properties
      |> Map.put("deal_owner_email", deal_owner.email)
      |> Map.put("contact_owner_email", contact_owner.email)
      |> Enum.map(fn {k, v} ->
        case k do
          "deal_owner_email" ->
            if(is_nil(v) or v == "",
              do: %{"missing_deal_owner" => "Missing ❌"},
              else: %{"missing_deal_owner" => "Got it ✅"}
            )

          "contact_owner_email" ->
            if(is_nil(v) or v == "",
              do: %{"missing_contact_owner" => "Missing ❌"},
              else: %{"missing_contact_owner" => "Got it ✅"}
            )

          "street_address" ->
            if(is_nil(v) or v == "",
              do: %{"missing_street_address" => "Missing ❌"},
              else: %{"missing_street_address" => "Got it ✅"}
            )

          "city" ->
            if(is_nil(v) or v == "",
              do: %{"missing_city" => "Missing ❌"},
              else: %{"missing_city" => "Got it ✅"}
            )

          "state_region" ->
            if(is_nil(v) or v == "" or String.length(v) > 2 or String.length(v) < 2,
              do: %{"missing_state_region" => "Missing or not using abbreviation ❌"},
              else: %{"missing_state_region" => "Got it ✅"}
            )

          "zip" ->
            if(is_nil(v) or v == "",
              do: %{"missing_zip" => "Missing ❌"},
              else: %{"missing_zip" => "Got it ✅"}
            )

          "email" ->
            if(is_nil(v) or v == "",
              do: %{"missing_email" => "Missing ❌"},
              else: %{"missing_email" => "Got it ✅"}
            )

          "first_name" ->
            if(is_nil(v) or v == "",
              do: %{"missing_first_name" => "Missing ❌"},
              else: %{"missing_first_name" => "Got it ✅"}
            )

          "last_name" ->
            if(is_nil(v) or v == "",
              do: %{"missing_last_name" => "Missing ❌"},
              else: %{"missing_last_name" => "Got it ✅"}
            )

          "phone_number" ->
            if(is_nil(v) or v == "",
              do: %{"missing_phone_number" => "Missing ❌"},
              else: %{"missing_phone_number" => "Got it ✅"}
            )

          "sales_area" ->
            if(is_nil(v) or v == "",
              do: %{"missing_sales_area" => "Missing ❌"},
              else: %{"missing_sales_area" => "Got it ✅"}
            )

          _ ->
            nil
        end
      end)
      |> List.flatten()
      |> Enum.filter(fn item -> item != nil end)
      |> List.insert_at(0, %{"deal_owner_email" => deal_owner.email})
      |> List.insert_at(0, %{"contact_owner_email" => contact_owner.email})
      |> Enum.reduce(%{}, fn missing_list, acc_map -> Map.merge(acc_map, missing_list) end)
    }
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
