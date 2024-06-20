defmodule ExTwilio.Recording do
  @moduledoc """
  Represents a Recording resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/voice/api/recording)
  """

  defstruct sid: nil,
            account_sid: nil,
            api_version: nil,
            call_sid: nil,
            conference_sid: nil,
            channels: nil,
            date_created: nil,
            date_updated: nil,
            duration: nil,
            start_time: nil,
            price: nil,
            price_unit: nil,
            source: nil,
            status: nil,
            error_code: nil,
            encryption_details: nil,
            track: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :destroy]

  def parents, do: [:account]
end
