defmodule ExTwilio.DependentPhoneNumber do
  @moduledoc """
  Represents an DependentPhoneNumber resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/dependent-phone-numbers)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list]

  def parents, do: [:account, :address]
end
