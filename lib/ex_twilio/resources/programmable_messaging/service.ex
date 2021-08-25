defmodule ExTwilio.ProgrammableMessaging.Service do
  @moduledoc """
  Represents a Service resource in the Twilio Programmable Messaging API.

  - [Twilio docs](https://www.twilio.com/docs/messaging/services/api)
  """
  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            date_created: nil,
            date_updated: nil,
            inbound_request_url: nil,
            inbound_method: nil,
            fallback_url: nil,
            fallback_method: nil,
            status_callback: nil,
            sticky_sender: nil,
            mms_converter: nil,
            smart_encoding: nil,
            scan_message_content: nil,
            fallback_to_long_code: nil,
            area_code_geomatch: nil,
            synchronous_validation: nil,
            validity_period: nil,
            url: nil,
            links: nil,
            use_inbound_webhook_on_number: nil

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
