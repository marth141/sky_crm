defmodule InfoTech.TrelloToTeamworkTransformer do
  def transform() do
    File.touch("trello_to_teamwork.csv")

    with {:ok, file} <- File.read("trello_tasks.json"),
         {:ok, json} <- Jason.decode(file),
         {:ok, dest_file} <- File.open("trello_to_teamwork.csv", [:write, :utf8]) do
      json["actions"]
      |> Enum.filter(fn action -> action["data"]["list"]["name"] == "Done" end)
      |> Enum.map(fn action ->
        [
          "From Trello",
          action["data"]["card"]["name"],
          action["data"]["card"]["desc"],
          "@org",
          action["date"] |> DateTimeParser.parse!() |> Timex.format!("{D}/{M}/{YYYY}"),
          action["date"] |> DateTimeParser.parse!() |> Timex.format!("{D}/{M}/{YYYY}"),
          "",
          "",
          "",
          "Completed"
        ]
      end)
      |> List.insert_at(0, [
        "TASKLIST",
        "TASK",
        "DESCRIPTION",
        "ASSIGN TO",
        "START DATE",
        "DUE DATE",
        "PRIORITY",
        "ESTIMATED TIME",
        "TAGS",
        "STATUS"
      ])
      |> CSV.encode()
      |> Enum.each(&IO.write(dest_file, &1))
    else
      {:error, error} -> {:error, error}
    end
  end
end
