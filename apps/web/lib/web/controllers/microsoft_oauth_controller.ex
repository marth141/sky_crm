defmodule Web.MicrosoftOauthController do
  use Web, :controller

  def index(conn, params) do
    params

    {:ok, %{body: body}} = OnedriveApi.get_delegated_access_token(params["code"])

    body = body |> Jason.decode!()

    {:ok, %{body: body}} = OnedriveApi.get_it_department_group_children(body["access_token"])

    body = Jason.decode!(body) |> IO.inspect()

    render(conn, "index.html")
  end
end
