defmodule ExTwilio.ProgrammableChat.Message do
  @moduledoc """
  Represents a Message resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/messages)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            to: nil,
            from: nil,
            date_created: nil,
            date_updated: nil,
            was_edited: nil,
            body: nil,
            attributes: nil,
            index: nil,
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

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.ProgrammableChat.Service, key: :service},
      %ExTwilio.Parent{module: ExTwilio.ProgrammableChat.Channel, key: :channel}
    ]
end
