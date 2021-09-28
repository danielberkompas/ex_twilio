defmodule ExTwilio.IncomingPhoneNumber do
  @moduledoc """
  Represents an IncomingPhoneNumber resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/phone-numbers/api/incomingphonenumber-resource)
  """

  defstruct sid: nil,
            account_sid: nil,
            address_sid: nil,
            address_requirements: nil,
            api_version: nil,
            beta: nil,
            capabilities: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            identity_sid: nil,
            phone_number: nil,
            origin: nil,
            sms_application_sid: nil,
            sms_fallback_method: nil,
            sms_fallback_url: nil,
            sms_method: nil,
            sms_url: nil,
            status: nil,
            status_callback: nil,
            status_callback_method: nil,
            trunk_sid: nil,
            uri: nil,
            voice_application_sid: nil,
            voice_caller_id_lookup: nil,
            voice_fallback_method: nil,
            voice_fallback_url: nil,
            voice_method: nil,
            voice_url: nil,
            emergency_status: nil,
            emergency_address_sid: nil,
            emergency_address_status: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]

  def parents, do: [:account]
end
