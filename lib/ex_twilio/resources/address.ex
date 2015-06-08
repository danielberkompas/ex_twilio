defmodule ExTwilio.Address do
  @moduledoc """
  Represents an Address resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/addresses)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            customer_name: nil,
            street: nil,
            city: nil,
            region: nil,
            postal_code: nil,
            iso_country: nil

  use ExTwilio.Resource, import: [:stream, :all, :create, :find, :update]

  def parents, do: [:account]
end
