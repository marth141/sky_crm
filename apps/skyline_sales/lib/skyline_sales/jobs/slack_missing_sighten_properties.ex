defmodule SkylineSales.Jobs.SlackMissingSightenProperties do
  use Oban.Worker, queue: :skyline_sales

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"received_deal" => received_deal, "missing_properties" => missing_properties},
        attempt: attempt
      }) do
    if attempt >= 10 do
      send_message_for_missing_properties(
        received_deal["hubspot_deal_id"],
        missing_properties
      )
    else
      {:error, "Missing properties but under 10 retries"}
    end
  end

  defp send_message_for_missing_properties(deal_id, missing_properties) do
    case {missing_properties["deal_owner_email"], missing_properties["contact_owner_email"],
          Enum.any?(missing_properties, fn {_k, v} ->
            String.contains?(v, "Missing")
          end)} do
      {nil, nil, true} ->
        IO.puts("Missing deal owner, contact owner, and other properties.")

        SkylineSales.slack_hubspot_helpdesk({:missing_sales_data, deal_id, missing_properties})

        {:ok, "slacked"}

      {deal_owner_email, nil, true} ->
        IO.puts("Missing contact owner and other properties")

        with {:ok, slack_user_id} <- SkylineSlack.find_user_id_via_email(deal_owner_email) do
          SkylineSlack.send_message_to_user(
            slack_user_id,
            SkylineSlack.create_missing_sales_data_message(deal_id, missing_properties)
          )

          {:ok, "slacked"}
        else
          {:error, message} ->
            IO.puts(message)

            SkylineSales.slack_hubspot_helpdesk(
              {:missing_sales_data, deal_id, missing_properties}
            )

            {:ok, "slacked"}
        end

      {nil, contact_owner_email, true} ->
        IO.puts("Missing deal owner and other properties")

        with {:ok, slack_user_id} <- SkylineSlack.find_user_id_via_email(contact_owner_email) do
          SkylineSlack.send_message_to_user(
            slack_user_id,
            SkylineSlack.create_missing_sales_data_message(deal_id, missing_properties)
          )

          {:ok, "slacked"}
        else
          {:error, message} ->
            IO.puts(message)

            SkylineSales.slack_hubspot_helpdesk(
              {:missing_sales_data, deal_id, missing_properties}
            )

            {:ok, "slacked"}
        end

      {deal_owner_email, contact_owner_email, true} ->
        IO.puts("Missing other properties")

        with {:ok, slack_deal_owner_user_id} <-
               SkylineSlack.find_user_id_via_email(deal_owner_email),
             {:ok, slack_contact_owner_user_id} <-
               SkylineSlack.find_user_id_via_email(contact_owner_email) do
          SkylineSlack.send_message_to_user(
            slack_deal_owner_user_id,
            SkylineSlack.create_missing_sales_data_message(deal_id, missing_properties)
          )

          SkylineSales.send_message_to_user(
            slack_contact_owner_user_id,
            SkylineSlack.create_missing_sales_data_message(deal_id, missing_properties)
          )

          {:ok, "slacked"}
        else
          {:error, message} ->
            IO.puts(message)

            SkylineSales.slack_hubspot_helpdesk(
              {:missing_sales_data, deal_id, missing_properties}
            )

            {:error, message}
        end

      {_deal_owner_email, _contact_owner_email, false} ->
        msg = "No missing info! 🎉"
        IO.puts(msg)
        {:ok, msg}
    end
  end
end
