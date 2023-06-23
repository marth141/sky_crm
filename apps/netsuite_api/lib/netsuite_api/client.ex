defmodule NetsuiteApi.Client do
  @moduledoc """
  Author(s) Nathan Casados (marth141 @ Github)

  This module details a Netsuite API Client for Org.

  It requires a consumer key & secret which can be retrieved from an
  "Integration" in Netsuite

  It also requires an API token & secret which can be retreived from
  "Access Tokens" in Netsuite

  The "realm" is the id at the beginning of a Org Netsuite link

  Because of how OAuthing works, and my own laziness, I have created multiple
  "new_" functions which make a Netsuite API Client with the "GET" or "POST" or
  "DELETE" or whatever other REST function is needed for Netsuite's REST API
  usage.

  Generally how we're using this is that we're funneling records in from Hubspot
  and into Netsuite via the customer endpoint. Netsuite API documentation can be
  found here

  https://system.netsuite.com/help/helpcenter/en_US/APIs/REST_API_Browser/record/v1/2021.2/index.html
  """
  @adapter Tesla.Adapter.Httpc

  defp consumer_key, do: Application.get_env(:netsuite_api, :consumer_key)

  defp consumer_secret,
    do: Application.get_env(:netsuite_api, :consumer_secret)

  defp token, do: Application.get_env(:netsuite_api, :token)
  defp token_secret, do: Application.get_env(:netsuite_api, :token_secret)
  defp realm, do: Application.get_env(:netsuite_api, :realm)
  defp realm_url do
    case Application.get_env(:netsuite_api, :env) do
      :dev -> "org-sb1"
      :prod -> "org"
    end
  end

  def new_get(endpoint) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "get",
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1#{endpoint}",
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params) |> IO.inspect(label: "Header")

    middleware = [
      {
        Tesla.Middleware.BaseUrl,
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1"
      },
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_get_restlet(endpoint) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "get",
        endpoint,
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params)

    middleware = [
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"},
         {"Content-Type", "application/json"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_post(endpoint) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "post",
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1#{endpoint}",
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params)

    middleware = [
      {
        Tesla.Middleware.BaseUrl,
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1"
      },
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_post_suiteql(url) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "post",
        url,
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params)

    middleware = [
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"},
         {"Prefer", "transient"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_delete(endpoint) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "delete",
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1#{endpoint}",
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params)

    middleware = [
      {
        Tesla.Middleware.BaseUrl,
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1"
      },
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def new_patch(endpoint) do
    creds =
      NetsuiteOAuth.credentials(
        consumer_key: consumer_key(),
        consumer_secret: consumer_secret(),
        token: token(),
        token_secret: token_secret(),
        realm: realm()
      )

    params =
      NetsuiteOAuth.sign(
        "patch",
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1#{endpoint}",
        [],
        creds
      )

    {header, _req_params} = NetsuiteOAuth.header(params)

    middleware = [
      {
        Tesla.Middleware.BaseUrl,
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/record/v1"
      },
      {Tesla.Middleware.Timeout, timeout: 60000},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         header,
         {"Cookie", "NS_ROUTING_VERSION=LAGGING"}
       ]}
    ]

    # adapter = opts[:adapter] || @adapter
    Tesla.client(middleware, @adapter)
  end

  def post(uri, params \\ %{}) do
    Tesla.post(new_post(uri), uri, params)
  end

  def post_suiteql(opts \\ []) do
    url =
      Keyword.get(
        opts,
        :url,
        "https://#{realm_url()}.suitetalk.api.netsuite.com/services/rest/query/v1/suiteql"
      )

    params = Keyword.get(opts, :params, %{})

    Tesla.post(
      new_post_suiteql(url),
      url,
      params
    )
  end

  def get(uri, opts \\ []) do
    Tesla.get(new_get(uri), uri, opts)
  end

  def get_restlet(uri, opts \\ []) do
    Tesla.get(new_get_restlet(uri), uri, opts)
  end

  def patch(uri, params \\ %{}) do
    Tesla.patch(new_patch(uri), uri, params)
  end

  def delete(uri) do
    Tesla.delete(new_delete(uri), uri)
  end
end
