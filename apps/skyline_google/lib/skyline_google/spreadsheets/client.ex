defmodule SkylineGoogle.Spreadsheets.Client do
  @moduledoc """
  Used to get a connection to Google Sheets.

  Elixir Google API Documentation
  https://github.com/googleapis/elixir-google-api (Umbrella documentation)
  https://github.com/googleapis/elixir-google-api/tree/master/clients/sheets (Sheets documentation)

  Google Admin Documentation
  https://support.google.com/accounts/answer/6010255?hl=en (Less Secure Apps)
  https://developers.google.com/admin-sdk/directory/v1/guides/delegation (Domain Wide Delegation)
  https://developers.google.com/apps-script/guides/projects (Projects, used to get config/creds.json)
  """

  @doc """
  Used to get values from a range.
  """
  def get_at_range(spreadsheet_id, range) do
    with {:ok, conn} <- authenticated_connection() do
      {:ok, response} =
        GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_get(
          conn,
          spreadsheet_id,
          range
        )

      response
    end
  end

  @doc """
  Used to set values to a range.
  """
  def set_at_range(spreadsheet_id, range, values) do
    with {:ok, conn} <- authenticated_connection() do
      GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_update(
        conn,
        spreadsheet_id,
        range,
        body: %{range: range, values: values},
        valueInputOption: "USER_ENTERED"
      )
    end
  end

  @doc """
  Used to set values to a range.
  """
  def clear_at_range(spreadsheet_id, range) do
    with {:ok, conn} <- authenticated_connection() do
      GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_clear(
        conn,
        spreadsheet_id,
        range,
        body: %{range: range},
        valueInputOption: "USER_ENTERED"
      )
    end
  end

  defp authenticated_connection() do
    with token <- get_authenticated_token(),
         conn <- get_connection(token) do
      {:ok, conn}
    end
  end

  defp get_authenticated_token do
    with {:ok, %{token: token}} <-
           Goth.Token.for_scope(
             "https://www.googleapis.com/auth/spreadsheets",
             "it_bot@org"
           ) do
      token
    else
      error ->
        IO.warn(error)
        nil
    end
  end

  defp get_connection(token) do
    GoogleApi.Sheets.V4.Connection.new(token)
  end
end
