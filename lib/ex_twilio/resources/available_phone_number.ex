defmodule ExTwilio.AvailablePhoneNumber do
  @moduledoc """
  Represents an AvailablePhoneNumber resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/available-phone-numbers)
  """

  defstruct friendly_name: nil,
            phone_number: nil,
            lata: nil,
            rate_center: nil,
            latitude: nil,
            longitude: nil,
            region: nil,
            postal_code: nil,
            iso_country: nil,
            capabilities: nil,
            address_requirements: nil

  use ExTwilio.Resource, import: [:stream, :all]

  def parents, do: [:account]
  def children, do: [:iso_country_code, :type]
end
