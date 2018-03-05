defmodule ExTwilio.OutgoingCallerId do
  @moduledoc """
  Represents an OutgoingCallerId resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/outgoing-caller-ids)
  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            account_sid: nil,
            phone_number: nil,
            validation_code: nil,
            call_sid: nil,
            uri: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]

  def parents, do: [:account]
end
