defmodule CopperApi.Client do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Defines a Tesla client for interacting with Copper via REST

  Does PUT, POST, GET, and DEL
  """
  @adapter Tesla.Adapter.Httpc

  defp copper_token, do: Application.get_env(:copper_api, :copper_api_token)

  defp copper_email, do: Application.get_env(:copper_api, :copper_api_email)

  def new(
        token \\ copper_token(),
        user_email \\ copper_email()
      ) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.copper.com/developer_api/v1/"},
      {Tesla.Middleware.Timeout, timeout: 10000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"X-PW-AccessToken", token},
         {"X-PW-Application", "developer_api"},
         {"X-PW-UserEmail", user_email},
         {"Content-Type", "application/json"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_download(
        token \\ copper_token(),
        user_email \\ copper_email()
      ) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://app.copper.com/companies/157251/file_documents"},
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"X-PW-AccessToken", token},
         {"X-PW-Application", "developer_api"},
         {"X-PW-UserEmail", user_email},
         {"Content-Type", "application/json"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def put(uri, params \\ %{}) do
    Tesla.put(new(), uri, params)
  end

  def post(uri, params \\ %{}) do
    Tesla.post(new(), uri, params)
  end

  def get(uri, opts \\ []) do
    Tesla.get(new(), uri, opts)
  end

  def get_download(uri, opts \\ []) do
    Tesla.get(new_download(), uri, opts)
  end

  def del(uri) do
    Tesla.delete(new(), uri)
  end
end
