defmodule ExTwilio.Recording do
  @moduledoc """
  Represents an Recording resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/recordings)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :destroy]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            call_sid: nil,
            duration: nil,
            api_version: nil,
            uri: nil
end
