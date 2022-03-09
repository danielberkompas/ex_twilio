defmodule ExTwilio.Address do
  @moduledoc """
  Represents an Address resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/usage/api/address)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            customer_name: nil,
            street: nil,
            street_secondary: nil,
            city: nil,
            region: nil,
            postal_code: nil,
            iso_country: nil

  use ExTwilio.Resource, import: [:stream, :all, :create, :destroy, :find, :update]

  def parents, do: [:account]
end
