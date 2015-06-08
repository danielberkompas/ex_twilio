defmodule ExTwilio.Transcription do
  @moduledoc """
  Represents an Transcription resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/transcriptions)
  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            status: nil,
            recording_sid: nil,
            duration: nil,
            transcription_text: nil,
            price: nil,
            price_unit: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :destroy]

  def parents, do: [:account, :recording]
end
