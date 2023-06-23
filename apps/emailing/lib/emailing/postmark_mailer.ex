defmodule Emailing.PostmarkMailer do
  @moduledoc """
  A mailer that uses Postmark for delivery.
  """
  use Swoosh.Mailer, otp_app: :emailing
end
