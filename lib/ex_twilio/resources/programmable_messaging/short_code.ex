defmodule ExTwilio.ProgrammableMessaging.ShortCode do
  @moduledoc """
  Represents a ShortCode resource in the Twilio Programmable Messaging API.

  - [Twilio docs](https://www.twilio.com/docs/messaging/services/api/shortcode-resource)
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            date_updated: nil,
            short_code: nil,
            country_code: nil,
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
