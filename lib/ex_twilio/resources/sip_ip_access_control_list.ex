defmodule ExTwilio.SipIpAccessControlList do
  @moduledoc """
  Represents an SIP IPAccessControlList in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/ip-access-control-list)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
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

  def resource_name, do: "SIP/IpAccessControlLists"
  def resource_collection_name, do: "ip_access_control_lists"
  def parents, do: [:account]
end
