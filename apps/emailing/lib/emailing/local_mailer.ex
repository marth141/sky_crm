defmodule Emailing.LocalMailer do
  @moduledoc """
  A mailer that uses a Local Process for delivery.

  Used for development environments to check your emails were sent or how they're formatted.
  """
  use Swoosh.Mailer, otp_app: :emailing
end
