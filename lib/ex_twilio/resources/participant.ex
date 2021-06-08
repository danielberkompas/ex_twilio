defmodule ExTwilio.Participant do
  @moduledoc """
  Represents a Participant resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/voice/api/conference-participant-resource)

  ## Examples

  Since Participants belong to Conferences in the Twilio API, you must pass a
  conference to each function in this module. For example:

      ExTwilio.Participant.all(conference: "conference_sid")

  """

  defstruct call_sid: nil,
            conference_sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            muted: nil,
            start_conference_on_enter: nil,
            end_conference_on_exit: nil,
            uri: nil,
            label: nil,
            call_sid_to_coach: nil,
            coaching: nil,
            hold: nil,
            status: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update, :create, :destroy]

  def parents, do: [:account, :conference]
end
