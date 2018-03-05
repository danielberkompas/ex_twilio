defmodule ExTwilio.ProgrammableChat.Member do
  @moduledoc """
  Represents a Member resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/members)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            channel_sid: nil,
            identity: nil,
            role_sid: nil,
            date_created: nil,
            date_updated: nil,
            last_consumed_message_index: nil,
            last_consumption_timestamp: nil,
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
