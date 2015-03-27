defmodule ExTwilio.Conference do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find]

  defstruct sid: nil,
            friendly_name: nil,
            status: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            uri: nil
end
