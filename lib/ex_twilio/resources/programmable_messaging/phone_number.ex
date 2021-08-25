defmodule ExTwilio.ProgrammableMessaging.PhoneNumber do
  @moduledoc """
  Represents a PhoneNumber resource in the Twilio Programmable Messaging API.

  - [Twilio docs](https://www.twilio.com/docs/messaging/services/api/phonenumber-resource)
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            date_updated: nil,
            phone_number: nil,
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
