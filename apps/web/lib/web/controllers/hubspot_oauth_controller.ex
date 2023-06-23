defmodule Web.HubspotOauthController do
  use Web, :controller

  def index(conn, params) do
    # Redirect_uri will need to change if prod
    string =
      "redirect_uri=https%3A%2F%2Flocalhost:4001%2Fa%2Fhubspot&grant_type=authorization_code&code=#{Map.get(params, "code")}&client_id=#{hubspot_client_id()}&client_secret=#{hubspot_client_secret()}"

    Finch.build(
      :post,
      "https://api.hubapi.com/oauth/v1/token",
      [{"Content-Type", "application/x-www-form-urlencoded"}],
      string
    )
    |> Finch.request(HubspotFinch)
    |> IO.inspect()

    IO.inspect(params["code"])

    render(conn, "index.html")
  end

  def inspect(conn, params) do
    IO.inspect(params)

    render(conn, "index.html")
  end

  # Might be unneeded. Using Authorization Bearer
  # Incase using OAuth 2, add client id and secret
  defp hubspot_client_id() do
    "paste_here"
  end

  # Might be unneeded. Using Authorization Bearer
  # Incase using OAuth 2, add client id and secret
  defp hubspot_client_secret() do
    "paste_here"
  end
end
