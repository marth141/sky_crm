defmodule SkylineSlack do
  @moduledoc """
  Documentation for `SkylineSlack`.

  This module is to be able to provide functions for stuff important to doing stuff with Org's slack.

  Some examples include sending a message to someone or a slack channel.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SkylineSlack.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Used to find a slack user id by the user email
  """
  def find_user_id_via_email(email_to_find) do
    with {:ok, user} <- find_user_via_email(email_to_find) do
      id = user |> Map.get("id")
      {:ok, id}
    else
      _error ->
        {:error, "Could not find slack user"}
    end
  end

  @doc """
  Used to bring back a whole slack user from their email
  """
  def find_user_via_email(email_to_find) do
    with [user] <-
           Slack.Web.Users.list()
           |> Map.get("members")
           |> Enum.filter(fn %{"profile" => profile} -> profile["email"] == email_to_find end) do
      {:ok, user}
    else
      [_head, _head2 | _tail] -> {:error, "No email given"}
      [] -> {:error, "User not found"}
    end
  end

  @doc """
  Finds a slack user by their id
  """
  def find_user_via_id(id_to_find) do
    Slack.Web.Users.list()
    |> Map.get("members")
    |> Enum.filter(fn %{"id" => id} -> id == id_to_find end)
  end

  @doc """
  Exports slack profiles
  """
  def export_slack_profiles() do
    File.touch("slack_profiles.csv")
    profiles_file = File.open!("slack_profiles.csv", [:write, :utf8])

    not_deleted_users =
      Slack.Web.Users.list()
      |> Map.get("members")
      |> Enum.filter(fn %{"deleted" => deleted} -> deleted == false end)

    profiles =
      not_deleted_users
      |> Enum.map(fn %{"profile" => profiles} -> profiles end)

    profiles
    |> convert_profiles_to_csv()
    |> Enum.each(&IO.write(profiles_file, &1))
  end

  @doc """
  Sdends a `message` to a user by their `user_id` as SkyCRM
  """
  def send_message_to_user(user_id, message) do
    Slack.Web.Chat.post_message(user_id, message)
  end

  @doc """
  Sends a message to a user via looking them up with their email as SkyCRM
  """
  def send_message_to_user_email(user_email, message) do
    with {:ok, user_id} <- find_user_id_via_email(user_email) do
      Slack.Web.Chat.post_message(user_id, message)
    else
      err -> err
    end
  end

  @doc """
  Sends hello to a user by thier `user_id` as SkyCRM
  """
  def send_hello_to_user(user_id) do
    display_name =
      find_user_via_id(user_id)
      |> List.first()
      |> Map.get("profile")
      |> Map.get("display_name")

    Slack.Web.Chat.post_message(user_id, "Hello #{display_name}!")
  end

  @doc """
  Sends the "SkyCRM Greeting" to a user as SkyCRM
  """
  def send_skycrm_greeting_to_user(user_id) do
    display_name =
      find_user_via_id(user_id)
      |> List.first()
      |> Map.get("profile")
      |> Map.get("display_name")

    Slack.Web.Chat.post_message(
      user_id,
      """
      Hello #{display_name}! Good to meet you!

      I am the SkyCRM! I will be used to send you messages about integrations I'm tied to.

      Presently I'm attached to...
      * Hubspot
      * Sighten
      * Slack
      * Netsuite

      Soon I'll be able to let someone know if their deal did not make it to Enerflo or Sighten :D
      """
    )
  end

  @doc """
  Sends a message to a channel as SkyCRM
  """
  def send_message_to_channel(channel, message) when is_binary(channel) and is_binary(message) do
    Slack.Web.Chat.post_message(
      channel,
      message
    )
  end

  @doc """
  Sends the "SkyCRM Greeting" to a channel as SkyCRM
  """
  def send_skycrm_greeting_to_channel(channel) do
    Slack.Web.Chat.post_message(
      channel,
      """
      Hello @channel! Good to meet you all!

      I am the SkyCRM! I will be used to send you messages about integrations I'm tied to.

      Presently I'm attached to...
      * Hubspot
      * Sighten
      * Slack
      * Netsuite

      Soon I'll be able to let someone know if their deal did not make it to Enerflo or Sighten :D
      """
    )
  end

  @doc """
  Broadcasts a message to #hubspot_helpdesk channel as SkyCRM
  """
  def broadcast_helpdesk_message(message) do
    send_message_to_channel("#hubspot_helpdesk", """
    ⚠️ Helpdesk Wide Broadcast ⚠️
    #{message}
    """)

    send_message_to_channel("#sighten_helpdesk", """
    ⚠️ Helpdesk Wide Broadcast ⚠️
    #{message}
    """)
  end

  @doc """
  Sends a slack to the SkyCRM Heldesk channel
  """
  def send_skycrm_helpdesk_message(message) do
    send_message_to_channel("#skycrm_helpdesk", message)
  end

  @doc """
  Sends @org a hello on slack as SkyCRM
  """
  def send_nate_hello() do
    Slack.Web.Chat.post_message("UT8JH18A2", "Hello")
  end

  @doc """
  Sends @org a message on slack as SkyCRM
  """
  def send_nate_a_message(message) do
    Slack.Web.Chat.post_message("UT8JH18A2", message)
  end

  @doc """
  Gets a user object for @org
  """
  def get_nates_user() do
    Slack.Web.Users.list()
    |> Map.get("members")
    |> Enum.filter(fn %{"profile" => %{"display_name" => display_name}} ->
      display_name == "N"
    end)
  end

  defp convert_profiles_to_csv([_first_item | _rest] = items) do
    columns = [
      "always_active",
      "avatar_hash",
      "display_name",
      "display_name_normalized",
      "email",
      "first_name",
      "image_192",
      "image_24",
      "image_32",
      "image_48",
      "image_512",
      "image_72",
      "last_name",
      "phone",
      "real_name",
      "real_name_normalized",
      "skype",
      "status_emoji",
      "status_expiration",
      "status_text",
      "status_text_canonical",
      "team",
      "title"
    ]

    Enum.map(items, fn item ->
      [
        item["always_active"],
        item["avatar_hash"],
        item["display_name"],
        item["display_name_normalized"],
        item["email"],
        item["first_name"],
        item["image_192"],
        item["image_24"],
        item["image_32"],
        item["image_48"],
        item["image_512"],
        item["image_72"],
        item["last_name"],
        item["phone"],
        item["real_name"],
        item["real_name_normalized"],
        item["skype"],
        item["status_emoji"],
        item["status_expiration"],
        item["status_text"],
        item["status_text_canonical"],
        item["team"],
        item["title"]
      ]
    end)
    |> List.insert_at(0, columns)
    |> CSV.encode()
  end

  @doc """
  Sends a message to the #hubspot_helpdesk as SkyCRM
  """
  def slack_hubspot_helpdesk({:missing_sales_data, object_id, missing_properties}) do
    SkylineSlack.send_message_to_channel(
      "#hubspot_helpdesk",
      create_missing_sales_data_message(object_id, missing_properties)
    )
  end

  @doc """
  Creates a message for missing sales data
  """
  def create_missing_sales_data_message(object_id, missing_properties) do
    """
    I tried to send a deal to EverBright.

    Please review if any properties are missing, here's what I got...

    *Deal Owner:* #{missing_properties["missing_deal_owner"]}
    *Contact Owner:* #{missing_properties["missing_contact_owner"]}
    *Street Address:* #{missing_properties["missing_street_address"]}
    *City:* #{missing_properties["missing_city"]}
    *State Region:* #{missing_properties["missing_state_region"]}
    *Zip:* #{missing_properties["missing_zip"]}
    *Email:* #{missing_properties["missing_email"]}
    *First Name:* #{missing_properties["missing_first_name"]}
    *Last Name:* #{missing_properties["missing_last_name"]}
    *Phone Number:* #{missing_properties["missing_phone_number"]}
    *Sales Area:* #{missing_properties["missing_sales_area"]}

    *Link:* https://app.hubspot.com/contacts/org/deal/#{object_id}
    """
  end
end
