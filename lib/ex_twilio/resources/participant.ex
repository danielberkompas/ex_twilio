defmodule ExTwilio.Participant do
  @moduledoc """
  Represents an Participant resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/participants)

  ## Examples

  Since Participants belong to Conferences in the Twilio API, you must pass a
  conference to each function in this module. For example:

      ExTwilio.Participant.list(conference: "conference_sid")
  """

  defstruct call_sid: nil,
            conference_sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            muted: nil,
            start_conference_on_enter: nil,
            end_conference_on_exit: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update, :create, :destroy]

  def parents, do: [:account, :conference]
end
