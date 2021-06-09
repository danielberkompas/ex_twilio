defmodule ExTwilio.Proxy.Message do
  @moduledoc """
  Represents a Message Interaction of a Session.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/sending-messages)
  """

  defstruct sid: nil,
            account_sid: nil,
            session_sid: nil,
            service_sid: nil,
            participant_sid: nil,
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

  use ExTwilio.Resource, import: [:create]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service},
      %ExTwilio.Parent{module: ExTwilio.Proxy.SessionResource, key: :session},
      %ExTwilio.Parent{module: ExTwilio.Proxy.Participant, key: :participant}
    ]

  def resource_name, do: "MessageInteractions"
end
