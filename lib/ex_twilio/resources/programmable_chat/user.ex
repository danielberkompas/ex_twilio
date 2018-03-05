defmodule ExTwilio.ProgrammableChat.User do
  @moduledoc """
  Represents a User resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/users)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            role_sid: nil,
            identity: nil,
            friendly_name: nil,
            attributes: nil,
            date_created: nil,
            date_updated: nil,
            is_online: nil,
            is_notifiable: nil,
            joined_channels_count: nil,
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
