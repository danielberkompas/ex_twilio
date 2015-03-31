defmodule ExTwilio.Participant do
  @moduledoc """
  Represents an Participant resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/participants)
  """

  use ExTwilio.Resource, import: [:stream, :list, :all, :find, :update, :destroy]

  defstruct call_sid: nil,
            conference_sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            muted: nil,
            start_conference_on_enter: nil,
            end_conference_on_exit: nil,
            uri: nil
end
