defmodule ExTwilio.ProgrammableChat.Credential do
  @moduledoc """
  Represents a Credential resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/credentials)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            type: nil,
            sandbox: nil,
            date_created: nil,
            date_updated: nil,
            url: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]
end
