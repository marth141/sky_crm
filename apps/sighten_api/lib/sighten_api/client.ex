defmodule SightenApi.Client do
  @moduledoc """
  This is the module that defines the API client stuff for working with sighten

  Mostly using `:POST` and `:GET`
  """
  @adapter Tesla.Adapter.Httpc

  defp sighten_token, do: Application.get_env(:sighten_api, :sighten_api_token)
  defp sighten_client_url, do: Application.get_env(:sighten_api, :client_url)

  def new(token \\ sighten_token()) do
    middleware = [
      {Tesla.Middleware.BaseUrl, sighten_client_url()},
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Token #{token}"},
         {"Content-Type", "application/json"}
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
end
