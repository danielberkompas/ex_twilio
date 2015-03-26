defmodule ExTwilio.Conference do
  defstruct sid: nil,
            friendly_name: nil,
            status: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            uri: nil

  use ExTwilio.Resource, import: [:list, :find]
end
