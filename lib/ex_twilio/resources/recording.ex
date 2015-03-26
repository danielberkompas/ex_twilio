defmodule ExTwilio.Recording do
  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            call_sid: nil,
            duration: nil,
            api_version: nil,
            uri: nil

  use ExTwilio.Resource, import: [:find, :destroy]
end
