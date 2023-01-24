defmodule ExTwilio.Verify.Verifications do
  @moduledoc """
  Represents a Verification resource in the Twilio Verify API.
  - [Twilio docs](https://www.twilio.com/docs/verify/api/verification)
  ## Examples
  Start a new verification using the specified service
      ExTwilio.Verify.Verifications.create(%{to: "+15017122661", channel: "sms"}, service: "VAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
  Twilio will send the user a token to use in a VerificationCheck. `create/2` will return `{:ok, verification_check}`, but be
  sure to check `verification_check.valid` for verification success.
      ExTwilio.Verify.VerificationCheck.create(%{to: "+15017122661", code: "1234"}, service: "VAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
  """
  defstruct sid: nil,
            service_sid: nil,
            account_sid: nil,
            to: nil,
            channel: nil,
            status: nil,
            valid: nil,
            date_created: nil,
            date_updated: nil,
            lookup: nil,
            amount: nil,
            payee: nil,
            send_code_attempts: nil,
            url: nil

  use ExTwilio.Resource,
    import: [
      :find,
      :create,
      :update
    ]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.Verify.Service, key: :service}
    ]
end
