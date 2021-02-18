defmodule ExTwilio.Proxy.Interaction do
  @moduledoc """
  Represents an Interaction of a Session.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/participant)
  """

  defstruct sid: nil,
            account_sid: nil,
            session_sid: nil,
            service_sid: nil,
            data: nil,
            type: nil,
            inbound_participant_sid: nil,
            inbound_resource_sid: nil,
            inbound_resource_status: nil,
            inbound_resource_type: nil,
            inbound_resource_url: nil,
            outbound_participant_sid: nil,
            outbound_resource_sid: nil,
            outbound_resource_status: nil,
            outbound_resource_type: nil,
            outbound_resource_url: nil,
            date_created: nil,
            date_updated: nil,
            url: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :delete]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service},
      %ExTwilio.Parent{module: ExTwilio.Proxy.Session, key: :session}
    ]
end
