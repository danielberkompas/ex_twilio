defmodule ExTwilio.ProgrammableChat.Role do
  @moduledoc """
  Represents a Message resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/roles)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            friendly_name: nil,
            type: nil,
            permissions: nil,
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

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.ProgrammableChat.Service, key: :service}]
end
