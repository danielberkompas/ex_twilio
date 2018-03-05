defmodule ExTwilio.SipCredential do
  @moduledoc """
  Represents an SIP Credential in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/credential-list#subresources)
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

  def resource_name, do: "Credentials"
  def resource_collection_name, do: "credentials"
  def parents, do: [:account, :sip_credential_list]
end
