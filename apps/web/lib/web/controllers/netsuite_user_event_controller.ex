defmodule Web.NetsuiteUserEventController do
  use Web, :controller

  def process_changes(conn, params) do
    get_new_and_old_record_field_differences(params["newRecord"], params["oldRecord"])
    |> process_field_changes(params["newRecord"]["id"])

    respond_ok(conn)
  end

  defp process_field_changes([{"comments", _comment} = h | t], id) do
    SkylineSlack.send_nate_a_message(
      "Comments were edited on https://org.app.netsuite.com/app/common/entity/custjob.nl?id=#{id}"
    )

    [h | process_field_changes(t, id)]
  end

  defp process_field_changes([h | t], id) do
    [h | process_field_changes(t, id)]
  end

  defp process_field_changes([], _id) do
    []
  end

  defp get_new_and_old_record_field_differences(new_record, old_record) do
    Map.to_list(new_record["fields"]) -- Map.to_list(old_record["fields"])
  end

  def inspect(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
    respond_ok(conn)
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end
end
