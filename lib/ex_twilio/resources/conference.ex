defmodule ExTwilio.Conference do
  @moduledoc """
  Represents an Conference resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/conference)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find]

  defstruct sid: nil,
            friendly_name: nil,
            status: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            uri: nil
end
