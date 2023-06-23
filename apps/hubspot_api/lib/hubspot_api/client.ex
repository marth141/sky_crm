defmodule HubspotApi.Client do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ Github)

  This module is to create a Hubspot API client for interacting with Hubspot's
  REST API endpoint.

  So far it just contains "POST", "GET", and "PATCH".

  This and all of the other API clients get their keys and tokens from system
  environment variables. Please check with Nate or the presiding IT Admin about
  getting those token keys.
  """
  @adapter Tesla.Adapter.Httpc

  defp hubspot_token, do: Application.get_env(:hubspot_api, :hubspot_api_token)

  def new() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.hubapi.com/"},
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"Content-Type", "application/json"},
         {"Authorization", "Bearer #{hubspot_token()}"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def post(uri, params \\ %{}) do
    Tesla.post(new(), uri, params)
  end

  def get(uri, opts \\ []) do
    Tesla.get(new(), uri, opts)
  end

  def patch(uri, params \\ %{}) do
    Tesla.patch(new(), uri, params)
  end
end
