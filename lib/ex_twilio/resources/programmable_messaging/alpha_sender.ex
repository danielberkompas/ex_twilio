defmodule ExTwilio.ProgrammableMessaging.AlphaSender do
  @moduledoc """
  Represents an AlphaSender resource in the Twilio Programmable Messaging API.

  - [Twilio docs](https://www.twilio.com/docs/messaging/services/api/alphasender-resource)
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            date_updated: nil,
            alpha_sender: nil,
            capabilities: nil,
            url: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :destroy
    ]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.ProgrammableMessaging.Service, key: :service}
    ]
end
