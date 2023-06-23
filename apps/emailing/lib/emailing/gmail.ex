defmodule Emailing.Gmail do
  @moduledoc """
  A mailer that uses Gmail for delivery.
  """
  use Swoosh.Mailer, otp_app: :emailing
end
