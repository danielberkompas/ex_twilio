defmodule ExTwilio.Proxy.Service do
  @moduledoc """
  A Service is a container for Proxy Sessions, Phone Numbers and Short Codes.
  Each of these items exists within a single Service and will not be shared across Services.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/service)
  """

  defstruct sid: nil,
            account_sid: nil,
            unique_name: nil,
            chat_instance_sid: nil,
            callback_url: nil,
            default_ttl: nil,
            number_selection_behavior: nil,
            geo_match_level: nil,
            intercept_callback_url: nil,
            out_of_session_callback_url: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]
end
