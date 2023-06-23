defmodule OnedriveApi do
  @moduledoc """
  Documentation for `OnedriveApi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> OnedriveApi.hello()
      :world

  """
  def hello do
    :world
  end

  def get_admin_consent() do
    client_id = Application.get_env(:onedrive_api, :client_id)
    redirect_uri = "https://localhost:4001/a/auth/microsoft"

    "https://login.microsoftonline.com/org/adminconsent?client_id=#{client_id}&state=12345&redirect_uri=#{redirect_uri}"
  end

  def get_delegated_consent() do
    client_id = Application.get_env(:onedrive_api, :client_id)
    client_secret = Application.get_env(:onedrive_api, :client_secret)

    "https://login.microsoftonline.com/org/oauth2/v2.0/authorize?client_id=#{client_id}&response_type=code&redirect_uri=https://localhost:4001/a/auth/microsoft&response_mode=query&scope=files.read.all&state=12345"
  end

  def get_delegated_access_token(token) do
    client_id = Application.get_env(:onedrive_api, :client_id)
    client_secret = Application.get_env(:onedrive_api, :client_secret)
    scope = "files.read.all"

    {:ok, %{body: body}} =
      Finch.build(
        :post,
        "https://login.microsoftonline.com/org/oauth2/v2.0/token",
        [{"Content-Type", "application/x-www-form-urlencoded"}],
        "client_id=#{client_id}&scope=#{scope}&code=#{token}&redirect_uri=https://localhost:4001/a/auth/microsoft&grant_type=authorization_code&client_secret=#{client_secret}"
      )
      |> Finch.request(MicrosoftFinch)
  end

  def refresh_delegated_access_token(refresh_token) do
    client_id = Application.get_env(:onedrive_api, :client_id)
    client_secret = Application.get_env(:onedrive_api, :client_secret)
    scope = "files.read.all"

    {:ok, %{body: body}} =
      Finch.build(
        :post,
        "https://login.microsoftonline.com/org/oauth2/v2.0/token",
        [{"Content-Type", "application/x-www-form-urlencoded"}],
        "client_id=#{client_id}&scope=#{scope}&refresh_token=#{refresh_token}&grant_type=refresh_token&client_secret=#{client_secret}"
      )
      |> Finch.request(MicrosoftFinch)
  end

  def upload_a_file(token) do
    Finch.build(
      :put,
      "https://graph.microsoft.com/v1.0/groups/74062eba-869b-41f9-bbd8-03f0b5930464/drive/items/root:/test.txt:/content",
      [
        {"Authorization", "Bearer #{token}"},
        {"Content-Type", "text/plain"}
      ],
      "Hello there"
    )
    |> Finch.request(MicrosoftFinch)
  end

  def upload_a_csv_to_power_bi_files(token, csv, title) do
    Finch.build(
      :put,
      "https://graph.microsoft.com/v1.0/groups/74062eba-869b-41f9-bbd8-03f0b5930464/drive/items/root:/Power%20BI%20Files/#{title}.csv:/content" |> String.replace(" ", "%20"),
      [
        {"Authorization", "Bearer #{token}"},
        {"Content-Type", "text/csv"}
      ],
      csv
    )
    |> Finch.request(MicrosoftFinch)
  end

  def get_it_department_group_drives(token) do
    Finch.build(
      :get,
      "https://graph.microsoft.com/v1.0/groups/74062eba-869b-41f9-bbd8-03f0b5930464/drives",
      [
        {"Authorization", "Bearer #{token}"}
      ]
    )
    |> Finch.request(MicrosoftFinch)
  end

  def get_it_department_group_children(token) do
    Finch.build(
      :get,
      "https://graph.microsoft.com/v1.0/groups/74062eba-869b-41f9-bbd8-03f0b5930464/drive/root/children",
      [
        {"Authorization", "Bearer #{token}"}
      ]
    )
    |> Finch.request(MicrosoftFinch)
  end

  def list_groups(token) do
    Finch.build(
      :get,
      "https://graph.microsoft.com/v1.0/groups",
      [
        {"Authorization", "Bearer #{token}"}
      ]
    )
    |> Finch.request(MicrosoftFinch)
  end

  def get_application_access_token() do
    client_id = Application.get_env(:onedrive_api, :client_id)
    client_secret = Application.get_env(:onedrive_api, :client_secret)
    scope = "https://graph.microsoft.com/.default"

    {:ok, %{body: body}} =
      Finch.build(
        :post,
        "https://login.microsoftonline.com/org/oauth2/v2.0/token",
        [{"Content-Type", "application/x-www-form-urlencoded"}],
        "client_id=#{client_id}&scope=#{scope}&client_secret=#{client_secret}&grant_type=client_credentials"
      )
      |> Finch.request(MicrosoftFinch)

    body |> Jason.decode!()
  end

  def get_nates_graph_user(token) do
    Finch.build(
      :get,
      "https://graph.microsoft.com/v1.0/users/898c90a0-e9f2-46c8-83d2-9ab9c07f1a93",
      [
        {"Authorization", "Bearer #{token}"}
      ]
    )
    |> Finch.request(MicrosoftFinch)
  end

  def get_nates_drive(token) do
    Finch.build(
      :get,
      "https://graph.microsoft.com/v1.0/me/drive",
      [
        {"Authorization", "Bearer #{token}"}
      ]
    )
    |> Finch.request(MicrosoftFinch)
  end
end
