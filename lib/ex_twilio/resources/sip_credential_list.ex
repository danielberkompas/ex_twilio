defmodule ExTwilio.SipCredentialList do
  @moduledoc """
  Represents an SIP CredentialList in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/credential-list)
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

  def resource_name, do: "SIP/CredentialLists"
  def resource_collection_name, do: "credential_lists"
  def parents, do: [:account]
end
