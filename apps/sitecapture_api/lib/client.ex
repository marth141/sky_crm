defmodule SitecaptureApi.Client do
  @adapter Tesla.Adapter.Httpc

  defp sitecapture_token, do: Application.get_env(:sitecapture_api, :api_token)

  defp authorization, do: Application.get_env(:sitecapture_api, :authorization_token)

  def new(token \\ sitecapture_token()) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.fotonotes.com/"},
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Basic #{authorization}"},
         {"API_KEY", "#{token}"},
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
