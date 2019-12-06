defmodule ExTwilio.Conference do
  @moduledoc """
  Represents an Conference resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/voice/api/conference-resource)
  """

  defstruct sid: nil,
            friendly_name: nil,
            status: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update]

  def parents, do: [:account]
end
