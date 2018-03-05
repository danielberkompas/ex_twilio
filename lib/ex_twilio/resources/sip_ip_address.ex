defmodule ExTwilio.SipIpAddress do
  @moduledoc """
  Represents an SIP IpAddress in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/ip-access-control-list#subresources)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            ip_address: nil,
            date_created: nil,
            date_updated: nil,
            uri: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]

  def resource_name, do: "IpAddresses"
  def resource_collection_name, do: "ip_addresses"
  def parents, do: [:account, :sip_ip_access_control_list]
end
