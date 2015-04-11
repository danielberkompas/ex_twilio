defmodule ExTwilio.SipIpAccessControlList do
  @moduledoc """
  Represents an SIP IPAccessControlList in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/ip-access-control-list)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            date_created: nil,
            date_updated: nil,
            uri: nil

  def resource_name, do: "SIP/IpAccessControlLists"
  def resource_collection_name, do: "ip_access_control_lists"
  def parents, do: [:account]
end
