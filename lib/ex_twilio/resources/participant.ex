defmodule ExTwilio.Participant do
  use ExTwilio.Resource, import: [:stream, :list, :all, :find, :update, :destroy]

  defstruct call_sid: nil,
            conference_sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            muted: nil,
            start_conference_on_enter: nil,
            end_conference_on_exit: nil,
            uri: nil
end
