defmodule ExTwilio.Transcription do
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

  use ExTwilio.Resource, import: [:list, :find, :destroy]
end
