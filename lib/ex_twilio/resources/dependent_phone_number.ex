defmodule ExTwilio.DependentPhoneNumber do
  @moduledoc """
  Represents an DependentPhoneNumber resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/dependent-phone-numbers)
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

  use ExTwilio.Resource, import: [:stream, :all, :list]

  def parents, do: [:account, :address]
end
