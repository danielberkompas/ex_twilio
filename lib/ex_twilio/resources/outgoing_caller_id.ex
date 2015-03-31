defmodule ExTwilio.OutgoingCallerId do
  @moduledoc """
  Represents an OutgoingCallerId resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/outgoing-caller-ids)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            account_sid: nil,
            phone_number: nil,
            validation_code: nil,
            call_sid: nil,
            uri: nil
end
