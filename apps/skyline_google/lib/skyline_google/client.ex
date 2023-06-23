defmodule SkylineGoogle.Client do
  @adapter {Tesla.Adapter.Finch, name: SkylineGoogleFinch}

  def new() do
    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/calendar",
        "@org"
      )

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.googleapis.com/"},
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Bearer #{token.token}"},
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
end
