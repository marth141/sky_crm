defmodule Web.EverBrightController do
  use Web, :controller

  def send_finance_contract_signed_message(conn, params) do
    contract_sub_tasks = params["sub_tasks"] |> List.first()

    if contract_sub_tasks["status"] == "COMP" do
      IO.puts("🙌 Completed Contract! 🙌")

      with {:ok, _status} <- SkylineOperations.send_finance_contract_signed_message(params) do
        respond_ok(conn)
      else
        {:error, _error} ->
          IO.puts("Error while Sending Contract Signed Message")
          respond_error(conn)
      end
    else
      respond_ok(conn)
    end
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end

  defp respond_error(conn) do
    json(conn, %{status: :error})
  end
end
