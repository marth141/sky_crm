defmodule SkylineGoogle do
  @moduledoc """
  Documentation for `SkylineGoogle`.
  """
  def topic(), do: inspect(__MODULE__)

  def subscribe, do: Messaging.subscribe(topic())

  def create_skysupport_calendar_event_from_hubspot_deal(calendar_event) do
    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/calendar",
        "it_bot@org"
      )

    g_conn = GoogleApi.Calendar.V3.Connection.new(token.token)

    {:ok, resp} =
      GoogleApi.Calendar.V3.Api.CalendarList.calendar_calendar_list_list(g_conn,
        domain: "org"
      )

    result =
      Enum.find(resp.items, fn %{id: id} ->
        id == "@group.calendar.google.com"
      end)

    GoogleApi.Calendar.V3.Api.Events.calendar_events_insert(g_conn, result.id,
      body: calendar_event
    )
  end

  def list_skysupport_calendar_events() do
    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/calendar",
        "it_bot@org"
      )

    g_conn = GoogleApi.Calendar.V3.Connection.new(token.token)

    {:ok, resp} =
      GoogleApi.Calendar.V3.Api.CalendarList.calendar_calendar_list_list(g_conn,
        domain: "org"
      )

    result =
      Enum.find(resp.items, fn %{id: id} ->
        id == "@group.calendar.google.com"
      end)

    GoogleApi.Calendar.V3.Api.Events.calendar_events_list(g_conn, result.id)
  end

  def watch_skysupport_calendar_events() do
    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/calendar",
        "@org"
      )

    IO.inspect(token)

    g_conn = GoogleApi.Calendar.V3.Connection.new(token.token)

    {:ok, resp} =
      GoogleApi.Calendar.V3.Api.CalendarList.calendar_calendar_list_list(g_conn,
        domain: "org"
      )

    result =
      Enum.find(resp.items, fn %{id: id} ->
        id == "@group.calendar.google.com"
      end)

    IO.inspect(result)

    resource = %GoogleApi.Calendar.V3.Model.Channel{
      expiration: "1628704029000",
      id: "test",
      kind: "api#channel",
      resourceId: "LjGH0H9J7zh5BTCRij3X8YRGc4w",
      resourceUri: "https://www.googleapis.com/calendar/v3/calendars/primary/events?alt=json"
    }

    GoogleApi.Calendar.V3.Api.Events.calendar_events_watch(g_conn, "primary", resource: resource)
  end

  def test_watch do
    SkylineGoogle.Client.post(
      "calendar/v3/calendars/primary/events/watch",
      %{
        "id" => "test",
        "token" => nil,
        "type" => "webhook",
        "address" => "https://skycrm.live/hookmon/mon_calendar",
        "params" => %{
          "ttl" => 604_800
        }
      }
    )
  end

  def test_stop_watch do
    SkylineGoogle.Client.post(
      "calendar/v3/channels/stop",
      %{
        "expiration" => "1628704029000",
        "id" => "test",
        "kind" => "api#channel",
        "resourceId" => "LjGH0H9J7zh5BTCRij3X8YRGc4w",
        "resourceUri" =>
          "https://www.googleapis.com/calendar/v3/calendars/primary/events?alt=json"
      }
    )
  end

  @doc """
  Updates a Google Drive File given as a `%GoogleApi.Drive.V3.Model.File{}`
  with a given `%GoogleApi.Drive.V3.Model.File{}` struct as the it_bot@org
  """
  def update_file(
        %GoogleApi.Drive.V3.Model.File{} = file,
        %GoogleApi.Drive.V3.Model.File{} = update
      ) do
    alias GoogleApi.Drive.V3.Api.Files

    g_conn = get_google_drive_connection(user_email: "it_bot@org")

    Files.drive_files_update(g_conn, file.id, body: update)
  end

  @doc """
  Gets a google drive connection for a given `:user_email`
  """
  def get_google_drive_connection(user_email: user_email) do
    alias GoogleApi.Drive.V3.Connection

    {:ok, token} =
      Goth.Token.for_scope(
        "https://www.googleapis.com/auth/drive",
        user_email
      )

    Connection.new(token.token)
  end

  @doc """
  TESTING
  Gets a folder where "Elixir" is in the name from @org's Google Drive
  """
  def get_folder_with_elixir_in_name() do
    alias GoogleApi.Drive.V3.Api.Files
    alias GoogleApi.Drive.V3.Model.FileList

    g_conn = get_google_drive_connection(user_email: "@org")

    {:ok,
     %FileList{
       files: files
     }} =
      Files.drive_files_list(g_conn,
        q: "mimeType = 'application/vnd.google-apps.folder' and fullText contains 'Elixir'"
      )

    files
  end

  @doc """
  Gets the "Netsuite BluBanyan Drive" as it_bot@org
  """
  def get_netsuite_blubanyan_drive() do
    alias GoogleApi.Drive.V3.Api.Drives
    alias GoogleApi.Drive.V3.Model.Drive
    alias GoogleApi.Drive.V3.Model.DriveList

    g_conn = get_google_drive_connection(user_email: "it_bot@org")

    {:ok,
     %DriveList{
       drives: drives
     }} = Drives.drive_drives_list(g_conn)

    find_netsuite_blubanyan_drive = fn drives ->
      drives
      |> Enum.find(fn
        %Drive{name: "Netsuite BluBanyan Drive"} -> true
        _ -> false
      end)
    end

    find_netsuite_blubanyan_drive.(drives)
  end

  @doc """
  Creates a stream getting "Netsuite BluBanyan Drive" folders
  """
  def stream_folders_from_netsuite_blubanyan_drive() do
    alias GoogleApi.Drive.V3.Model.FileList

    Stream.resource(
      # Gets the first page of folders in the Netsuite BluBanyan Drive
      fn -> list_folders_in_netsuite_blubanyan_drive() end,
      # For every FileList retrieved from
      # `list_folders_in_netsuite_blubanyan_drive`
      # Collect the `files` and pass on the next FileList
      fn
        %FileList{nextPageToken: next_page_token, files: files}
        when not is_nil(next_page_token) ->
          next_file_list = list_folders_in_netsuite_blubanyan_drive(pageToken: next_page_token)

          {files, next_file_list}

        # If the `next_page_token` is nil, collect last files
        # then return nil for FileList
        %FileList{nextPageToken: next_page_token, files: files} when is_nil(next_page_token) ->
          {files, nil}

        # If the FileList is nil, :halt
        nil ->
          {:halt, nil}
      end,
      # Ends the list
      fn nil ->
        nil
      end
    )
  end

  @doc """
  Lists the first page of folders in the Org "Netsuite BluBanyan Drive"
  which hosts BluDocs--as it_bot@org
  """
  def list_folders_in_netsuite_blubanyan_drive() do
    alias GoogleApi.Drive.V3.Model.Drive
    alias GoogleApi.Drive.V3.Api.Files

    g_conn = get_google_drive_connection(user_email: "it_bot@org")

    %Drive{id: id} = get_netsuite_blubanyan_drive()

    with {:ok, list} <-
           Files.drive_files_list(g_conn,
             driveId: id,
             includeItemsFromAllDrives: true,
             corpora: "drive",
             supportsAllDrives: true,
             pageSize: 1000,
             q: "mimeType = 'application/vnd.google-apps.folder'",
             fields: "files(parents, id, name)"
           ) do
      list
    else
      {:error, %{status: 500}} -> list_folders_in_netsuite_blubanyan_drive()
      {:error, %{status: 429}} -> list_folders_in_netsuite_blubanyan_drive()
    end
  end

  @doc """
  Lists the given next page page of folders in the Org "Netsuite BluBanyan Drive"
  which hosts BluDocs--as it_bot@org
  """
  def list_folders_in_netsuite_blubanyan_drive(pageToken: next_page_token) do
    alias GoogleApi.Drive.V3.Api.Files
    alias GoogleApi.Drive.V3.Model.Drive

    g_conn = get_google_drive_connection(user_email: "it_bot@org")

    %Drive{id: id} = get_netsuite_blubanyan_drive()

    with {:ok, list} <-
           Files.drive_files_list(g_conn,
             driveId: id,
             includeItemsFromAllDrives: true,
             corpora: "drive",
             supportsAllDrives: true,
             pageToken: next_page_token,
             pageSize: 1000,
             q: "mimeType = 'application/vnd.google-apps.folder'",
             fields: "files(parents, id, name)"
           ) do
      list
    else
      {:error, %{status: 500}} ->
        list_folders_in_netsuite_blubanyan_drive(pageToken: next_page_token)

      {:error, %{status: 429}} ->
        list_folders_in_netsuite_blubanyan_drive(pageToken: next_page_token)
    end
  end
end
