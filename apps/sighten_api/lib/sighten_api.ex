defmodule SightenApi do
  @moduledoc """
  Documentation for `SightenApi`.

  This module is for wrapping commands that would otherwise get some kind of information or put some kind of
  information into Sighten.

  As of 2022/02/21 (Feb 21st, 2022) Sighten has been bought by "GoEverbright"

  """

  @doc """
  Hello world.

  ## Examples

      iex> SightenApi.hello()
      :world

  """
  def hello do
    :world
  end

  def topic(), do: inspect(__MODULE__)

  def subscribe, do: Messaging.subscribe(topic())

  def publish(message),
    do: Messaging.publish(topic(), message)

  def unsubscribe(),
    do: Messaging.unsubscribe(topic())

  @doc """
  Gets a completed contract from Sighten
  """
  def fetch_completed_contract(site_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/v1/contract?site_id=#{site_id}") do
      contracts =
        body["results"]
        |> Enum.reject(fn result -> result["status"] != "COMP" end)

      unless contracts == [], do: {:ok, contracts}, else: {:error, "No Completed Contracts"}
    end
  end

  @doc """
  Fetches a contract out of sighten
  """
  def fetch_contract(contract_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/v1/contract/#{contract_id}") do
      body
    end
  end

  @doc """
  Fetches a proposal labeled "hubspot" out of sighten from a site
  """
  def fetch_hubspot_proposal(site_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/v1/proposal?site_id=#{site_id}") do
      proposals =
        body["results"]
        |> Enum.reject(fn result -> !String.match?(result["name"], ~r/hubspot/i) end)

      unless proposals == [], do: {:ok, proposals}, else: {:error, "No Hubspot Proposals"}
    end
  end

  @doc """
  Fetches proposals from a sighten site
  """
  def fetch_proposals(site_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/v1/proposal?site_id=#{site_id}") do
      proposals = body["results"]

      unless proposals == [], do: {:ok, proposals}, else: {:error, "No Proposals"}
    end
  end

  @doc """
  Transforms a given input into a request for creating a sighten site
  """
  def cast_as_sighten_site_request(transformee) do
    with {:ok, create_site_request} <- SightenApi.CreateSiteRequest.new(transformee) do
      {:ok, create_site_request}
    end
  end

  @doc """
  Fetches "array_inverter_count" from a sighten `:proposal` or `:quote`
  """
  def fetch_array_inverter_count(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=array_inverter_count"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_inverter_count"}
    end
  end

  def fetch_array_inverter_count(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=array_inverter_count"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_inverter_count"}
    end
  end

  @doc """
  Fetches "financing_fees" from a sighten `:proposal` or `:quote`
  """
  def fetch_financing_fees(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=financing_fees"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch financing_fees"}
    end
  end

  def fetch_financing_fees(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=financing_fees") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch financing_fees"}
    end
  end

  @doc """
  Fetches "system_production_monthly_avg" from a sighten `:proposal` or `:quote`
  """
  def fetch_system_production_monthly_avg(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=system_production_monthly_avg"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_production_monthly_avg"}
    end
  end

  def fetch_system_production_monthly_avg(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=system_production_monthly_avg"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_production_monthly_avg"}
    end
  end

  @doc """
  Fetches "array_module_count" from a sighten `:proposal` or `:quote`
  """
  def fetch_array_module_count(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=array_module_count"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_module_count"}
    end
  end

  def fetch_array_module_count(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=array_module_count") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_module_count"}
    end
  end

  @doc """
  Fetches "site_estimated_usage_in_first_year" from a sighten `:proposal` or `:quote`
  """
  def fetch_site_estimated_usage_in_first_year(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=site_estimated_usage_in_first_year"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch site_estimated_usage_in_first_year"}
    end
  end

  def fetch_site_estimated_usage_in_first_year(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=site_estimated_usage_in_first_year"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch site_estimated_usage_in_first_year"}
    end
  end

  @doc """
  Fetches "array_tilt" from a sighten `:proposal` or `:quote`
  """
  def fetch_array_tilt(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=array_tilt"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_tilt"}
    end
  end

  def fetch_array_tilt(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=array_tilt") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_tilt"}
    end
  end

  @doc """
  Fetches "array_count" from a sighten `:proposal` or `:quote`
  """
  def fetch_array_count(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=array_count"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_count"}
    end
  end

  def fetch_array_count(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=array_count") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_count"}
    end
  end

  @doc """
  Fetches "array_type" from a sighten `:proposal` or `:quote`
  """
  def fetch_array_type(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=array_type"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_type"}
    end
  end

  def fetch_array_type(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=array_type") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch array_type"}
    end
  end

  @doc """
  Fetches "inverter_rating_nominal" from a sighten `:proposal` or `:quote`
  """
  def fetch_inverter_rating_nominal(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=inverter_rating_nominal"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch inverter_rating_nominal"}
    end
  end

  def fetch_inverter_rating_nominal(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=inverter_rating_nominal"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch inverter_rating_nominal"}
    end
  end

  @doc """
  Fetches "module_rating_nominal" from a sighten `:proposal` or `:quote`
  """
  def fetch_module_rating_nominal(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=module_rating_nominal"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch module_rating_nominal"}
    end
  end

  def fetch_module_rating_nominal(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=module_rating_nominal"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch module_rating_nominal"}
    end
  end

  @doc """
  Fetches "module_model" from a sighten `:proposal` or `:quote`
  """
  def fetch_module_model(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=module_model"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch module_model"}
    end
  end

  def fetch_module_model(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=module_model") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch module_model"}
    end
  end

  @doc """
  Fetches "inverter_model" from a sighten `:proposal` or `:quote`
  """
  def fetch_inverter_model(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=inverter_model"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch inverter_model"}
    end
  end

  def fetch_inverter_model(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=inverter_model") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch inverter_model"}
    end
  end

  @doc """
  Fetches "efficiency_equipment_type" from a sighten `:proposal` or `:quote`
  """
  def fetch_efficiency_equipment_type(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=efficiency_equipment_type"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch efficiency_equipment_type"}
    end
  end

  def fetch_efficiency_equipment_type(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=efficiency_equipment_type"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch efficiency_equipment_type"}
    end
  end

  @doc """
  Fetches "battery_model" from a sighten `:proposal` or `:quote`
  """
  def fetch_battery_model(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=battery_model"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch battery_model"}
    end
  end

  def fetch_battery_model(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=battery_model") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch battery_model"}
    end
  end

  @doc """
  Fetches "battery_count" from a sighten `:proposal` or `:quote`
  """
  def fetch_battery_count(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=battery_count"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch battery_count"}
    end
  end

  def fetch_battery_count(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=battery_count") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch battery_count"}
    end
  end

  @doc """
  Fetches "system_production_in_first_year" from a sighten `:proposal` or `:quote`
  """
  def fetch_system_production_in_first_year(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=system_production_in_first_year"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_production_in_first_year"}
    end
  end

  def fetch_system_production_in_first_year(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=system_production_in_first_year"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_production_in_first_year"}
    end
  end

  @doc """
  Fetches "proposal_date_created" from a sighten `:proposal` or `:quote`
  """
  def fetch_proposal_date_created(:proposal, nil) do
    {:ok, [%{"proposal_date_created" => nil}]}
  end

  def fetch_proposal_date_created(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=proposal_date_created"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch proposal_date_created"}
    end
  end

  def fetch_proposal_date_created(:quote, nil) do
    {:ok, [%{"proposal_date_created" => nil}]}
  end

  def fetch_proposal_date_created(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/quote?quote_id=#{quote_id}&metrics=proposal_date_created"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch proposal_date_created"}
    end
  end

  @doc """
  Fetches "site_usage_offset" from a sighten `:proposal` or `:quote`
  """
  def fetch_site_usage_offset(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=site_usage_offset"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch site_usage_offset"}
    end
  end

  def fetch_site_usage_offset(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=site_usage_offset") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch site_usage_offset"}
    end
  end

  @doc """
  Fetches "system_capacity_kw" from a sighten `:proposal` or `:quote`
  """
  def fetch_system_capacity_kw(:proposal, proposal_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get(
             "api/data/proposal?proposal_id=#{proposal_id}&metrics=system_capacity_kw"
           ) do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_capacity_kw"}
    end
  end

  def fetch_system_capacity_kw(:quote, quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=system_capacity_kw") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not fetch system_capacity_kw"}
    end
  end

  @doc """
  Fetches a quote by its id
  """
  def fetch_quote_by_id(quote_id) do
    SightenApi.Client.get("api/v1/quote/#{quote_id}")
  end

  @doc """
  Fetches the install cost from a quote by id
  """
  def fetch_quote_install_cost(quote_id) do
    with {:ok, %{status: 200, body: body}} <- SightenApi.Client.get("api/v1/quote/#{quote_id}") do
      IO.inspect(body)
      {:ok, body["install_cost"]}
    else
      _ -> {:error, "Could not get install cost"}
    end
  end

  @doc """
  Fetches a quote's proposals by quote id
  """
  def fetch_quote_proposals(quote_id) do
    with {:ok, %{status: 200, body: body}} <-
           SightenApi.Client.get("api/data/quote?quote_id=#{quote_id}&metrics=proposal_id") do
      {:ok, body["data"]}
    else
      _ -> {:error, "Could not get proposals for quote"}
    end
  end

  @doc """
  Fetches a site by id
  """
  def fetch_site_by_id(site_id) do
    {:ok, %{body: body}} = SightenApi.Client.get("api/v1/site/#{site_id}")

    body
    |> SightenApi.Schemas.Site.new()
  end

  @doc """
  Creates a sighten site from a `CreateSiteRequest` struct
  """
  def create_site_in_sighten(%SightenApi.CreateSiteRequest{
        street_address: street_address,
        city: city,
        state_region: state_region,
        zip: zip,
        first_name: first_name,
        last_name: last_name,
        email: email,
        external_id: external_id,
        phone_number: _phone_number
      }) do
    SightenApi.Client.post(
      "/api/v1/site/",
      %{
        "address" => %{
          "address_line_1" => street_address,
          "city_name" => city,
          "state_abbreviation" => state_region,
          "zipcode" => zip
        },
        "contacts" => [
          %{
            "first_name" => first_name,
            "last_name" => last_name,
            "email" => email,
            "primary" => true
          }
        ],
        "external_id" => to_string(external_id)
      }
    )
  end

  @doc """
  Get's the proposals for a site by id
  """
  def get_proposals_for_site_id(site_id) do
    SightenApi.Client.get("/api/v1/proposal?site_id=#{site_id}")
  end

  @doc """
  Tests creating a sighten site
  """
  def test_create_site_in_sighten() do
    SightenApi.Client.post(
      "/api/v1/site/",
      %{
        "address" => %{
          "address_line_1" => "85 Palmer Loop",
          "city_name" => "Eagle",
          "state_abbreviation" => "CO",
          "zipcode" => "81631"
        },
        "contacts" => [
          %{
            "first_name" => "Nathan",
            "last_name" => "Casados",
            "email" => "abmctkno@hotmail.com",
            "primary" => true
          }
        ],
        "external_id" => "5383685661"
      }
    )
  end
end
