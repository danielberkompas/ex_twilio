defmodule ExTwilio.ProgrammableChat.Channel do
  @moduledoc """
  Represents a Channel resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/channels)
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            unique_name: nil,
            friendly_name: nil,
            attributes: nil,
            type: nil,
            date_created: nil,
            date_updated: nil,
            created_by: nil,
            members_count: nil,
            messages_count: nil,
            url: nil,
            links: nil

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
