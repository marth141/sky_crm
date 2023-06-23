defmodule SkylineOperations.Jobs.BackupCopperOpportunityFiles do
  use Oban.Worker, queue: :collector

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    :ok
  end

  def list_of_files() do
    [
      %{
        "content_type" => "binary/octet-stream",
        "creator_id" => 823_240,
        "date_created" => 1_629_919_351,
        "date_modified" => nil,
        "file_name" => "elite_dangerous_wallpaper.jpg",
        "file_size" => 563_234,
        "id" => 826_205_479,
        "is_deleted" => false
      },
      %{
        "content_type" => "binary/octet-stream",
        "creator_id" => 823_240,
        "date_created" => 1_629_919_351,
        "date_modified" => nil,
        "file_name" => "elite_dangerous_wallpaper.jpg",
        "file_size" => 563_234,
        "id" => 826_205_479,
        "is_deleted" => false
      }
    ]
  end

  def tinker_toy(input) do
    input
    |> Enum.chunk_every(180)
    |> Task.async_stream(fn chunk ->
      Process.sleep(100)

      chunk
      |> Task.async_stream(fn [opportunity_id, opportunity_name] ->
        [
          opportunity_name,
          "https://app.copper.com/companies/157251/app#/deal/#{opportunity_id}",
          "Some JSON!"
        ]
      end)
      |> Stream.map(fn {:ok, el} -> el end)
      |> Enum.to_list()
    end)
    |> Stream.map(fn {:ok, el} -> el end)
    |> Enum.to_list()
    |> Enum.flat_map(fn chunk -> chunk end)
    |> write_to_csv("opportunities_and_download_links")
  end

  @spec write_to_csv([[any]], String.t()) :: :ok
  def write_to_csv(array_of_arrays, title) do
    File.touch("#{title}.csv")
    file = File.open!("#{title}.csv", [:write, :utf8])

    array_of_arrays
    |> CSV.encode()
    |> Enum.each(&IO.write(file, &1))
  end

  def get_files_for_list_of_opportunities(list_of_opportunities) do
    list_of_opportunities
    |> Enum.chunk_every(180)
    |> Enum.map(fn chunk ->
      Process.sleep(2000)

      chunk
      |> Task.async_stream(
        fn [opportunity_id, opportunity_name, hubspot_id] ->
          get_download_csv_row(opportunity_id, opportunity_name, hubspot_id)
        end,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, el} -> el end)
      |> Enum.to_list()
    end)
    # |> Stream.map(fn {:ok, el} -> el end)
    # |> Enum.to_list()
    |> Enum.flat_map(fn chunk -> chunk end)
    |> write_to_csv("opportunities_and_download_links#{Enum.random(1..100)}")
  end

  defp get_download_csv_row(opportunity_id, opportunity_name, hubspot_id) do
    with {:ok, %{body: body, status: 200}} <- get_files_for_opportunity_id(opportunity_id) do
      [
        opportunity_id,
        hubspot_id,
        opportunity_name,
        "https://app.copper.com/companies/157251/app#/deal/#{opportunity_id}",
        body
        |> create_download_link()
      ]
      |> List.flatten()
    else
      _ ->
        Process.sleep(5000)
        get_download_csv_row(opportunity_id, opportunity_name, hubspot_id)
    end
  end

  def get_files_for_opportunity_id(opportunity_id) do
    CopperApi.Client.get("opportunities/#{opportunity_id}/files")
  end

  @doc """
  To create a download link for a copper record.

  Use CopperApi.get_files_for(:type_atom, id_int) to get a response about files for a record.

  Then, creates the link.
  """
  def create_download_link(nil) do
    {:error, "No file id passed"}
  end

  def create_download_link([_h | _t] = list_of_files) do
    Enum.map(list_of_files, fn file -> create_download_link(file["id"]) end)
  end

  def create_download_link(file_id) do
    "https://app.copper.com/companies/157251/file_documents/#{file_id}/download"
  end

  def download_files(download_links) do
    {:ok, Enum.map(download_links, fn {:ok, link} -> CopperApi.Client.get_download(link) end)}
  end
end
