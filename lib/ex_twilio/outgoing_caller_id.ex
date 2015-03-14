defmodule ExTwilio.OutgoingCallerId do
  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            account_sid: nil,
            phone_number: nil,
            validation_code: nil,
            call_sid: nil,
            uri: nil

  use ExTwilio.Api
end
