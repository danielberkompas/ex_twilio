defmodule ExTwilio.Address do
  use ExTwilio.Resource, import: [:stream, :all, :list, :create, :find, :update]

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            customer_name: nil,
            street: nil,
            city: nil,
            region: nil,
            postal_code: nil,
            iso_country: nil
end
