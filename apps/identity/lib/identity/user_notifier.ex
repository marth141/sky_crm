defmodule Identity.UserNotifier do
  @moduledoc """
  User Notifications
  """
  alias Swoosh.Email

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    Email.new()
    |> Email.to(user.email)
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("Confirm your account with the SkyCRM")
    |> Email.text_body("""
        Hi #{user.email},

        You can confirm your account by visiting the url: #{url}

        If you didn't create an account with us, please ignore this.
    """)
    |> Emailing.deliver()
  end

  @doc """
  Deliver instructions to reset password account.
  """
  def deliver_reset_password_instructions(user, url) do
    Email.new()
    |> Email.to(user.email)
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("Reset the password for your SkyCRM account")
    |> Email.text_body("""
      Hi #{user.email},

      You can reset your password by visiting the url: #{url}

      If you didn't request this change, please ignore this.
    """)
    |> Emailing.deliver()
  end

  @doc """
  Deliver instructions to update your e-mail.
  """
  def deliver_update_email_instructions(user, url) do
    Email.new()
    |> Email.to(user.email)
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("Change the email for your SkyCRM account")
    |> Email.text_body("""
      Hi #{user.email},

      You can change your e-mail by visiting the url: #{url}

      If you didn't request this change, please ignore this.
    """)
    |> Emailing.deliver()
  end
end
