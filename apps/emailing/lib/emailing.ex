defmodule Emailing do
  @moduledoc """
  Used for emailing within SkyCRM.

  Provides a common interface that hides things like Mailer configuration behind `deliver`.

  ## Example

  ```
  alias Swoosh.Email

  Email.new()
  |> Email.to({user.name, user.email})
  |> Email.from({"Dr B Banner", "hulk.smash@example.com"})
  |> Email.subject("Hello, Avengers!")
  |> Email.text_body("Hulk Smash!")
  |> Emailing.deliver()
  ```

  As the content of an email is a per-context/per-workflow concern that code will reside within the context.

  This module is only responsible for how to build and deliver emails. It shouldn't contain logic about what
  the email contents are.

  For example within your context / business logic application you might want to make a module containing
  all functions for "User Notification."

  ```
  defmodule Identity.UserNotifications do
    alias Swoosh.Email

    def deliver_agent_reset_password_instructions(agent, reset_url) do
      Email.new()
      |> Email.to({agent.first_name <> " " <> agent.last_name, agent.email})
      |> Email.from({"SkyCRM", "do-not-reply@org.com"})
      |> Email.subject("Your SkyCRM password has been reset")
      |> Email.text_body(\"""
        Your SkyCRM Password has been reset.

        You can set a new password for your account by visiting the url url below:

        some_url
      \""")
      |> Emailing.deliver()
    end
  end
  """
  alias Swoosh.Email
  alias SkylineGoogle

  def test() do
    Email.new()
    |> Email.to("@org")
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("Test Email")
    |> Email.html_body("""
    Test from SkyCRM
    """)
    |> Emailing.deliver()
  end

  @doc """
  Delivers an email with a default adapter per environment or whatever adapter you configure.
  """
  def deliver(%Email{} = email, mailer_config \\ default_adapter_config()) do
    mailer = Keyword.get(mailer_config, :adapter)

    mailer.deliver(email, build_config(mailer_config))
  end

  # this gets the emailer configured in our app env
  defp default_adapter_config, do: Application.fetch_env!(:emailing, :mailer)

  # this lets us fetch and inject additional configuration at runtime depending on the adapter
  # in this case if the adapter is gmail, we grab a temporary, scoped, token and pass it in before email delivery
  defp build_config([adapter: Swoosh.Adapters.Gmail] = config) do
    Keyword.put(config, :access_token, SkylineGoogle.Gmail.get_authenticated_token())
  end

  defp build_config(config), do: config

  def topic(), do: inspect(__MODULE__)

  def subscribe, do: Messaging.subscribe(topic())

  def publish(message),
    do: Messaging.publish(topic(), message)

  def unsubscribe(),
    do: Messaging.unsubscribe(topic())
end
