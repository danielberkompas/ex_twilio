defmodule ExTwilio.SipDomain do
  @moduledoc """
  Represents an SIP Domain resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/voice/sip/api/sip-domain-resource)
  """

  defstruct sid: nil,
            friendly_name: nil,
            account_sid: nil,
            api_version: nil,
            domain_name: nil,
            auth_type: nil,
            voice_url: nil,
            voice_method: nil,
            voice_fallback_url: nil,
            voice_fallback_method: nil,
            voice_status_callback_url: nil,
            voice_status_callback_method: nil,
            emergency_caller_sid: nil,
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

  def resource_name, do: "SIP/Domains"
  def resource_collection_name, do: "domains"
  def parents, do: [:account]
end
