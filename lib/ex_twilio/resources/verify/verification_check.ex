defmodule ExTwilio.Verify.VerificationCheck do
  @moduledoc """
  Represents a VerificationCheck resource in the Twilio Verify API.
  - [Twilio docs](https://www.twilio.com/docs/verify/api/verification-check)
  """
  defstruct sid: nil,
            service_sid: nil,
            account_sid: nil,
            to: nil,
            channel: nil,
            status: nil,
            valid: nil,
            amount: nil,
            payee: nil,
            date_created: nil,
            date_updated: nil

  use ExTwilio.Resource, import: [:create]
  def parents, do: [%ExTwilio.Parent{module: ExTwilio.Verify.Service, key: :service}]
  def resource_name, do: "VerificationCheck"
end
