defmodule Emailing.TestMailer do
  @moduledoc """
  A mailer used for test environments.

  Use with `Swoosh.TestAssertions` in tests to assert an email was delivered as part of a workflow.
  """
  use Swoosh.Mailer, otp_app: :emailing
end
