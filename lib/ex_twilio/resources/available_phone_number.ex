defmodule ExTwilio.AvailablePhoneNumber do
  use ExTwilio.Resource, import: [:stream, :all, :list]

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
end
