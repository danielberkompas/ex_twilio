defmodule ExTwilio.ShortCode do
  @moduledoc """
  Represents a ShortCode resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/short-codes)
  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            account_sid: nil,
            short_code: nil,
            api_version: nil,
            sms_url: nil,
            sms_method: nil,
            sms_fallback_url: nil,
            sms_fallback_url_method: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update]

  def resource_name, do: "SMS/ShortCodes"
  def parents, do: [:account]
end
