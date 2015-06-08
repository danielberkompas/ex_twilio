defmodule ExTwilio.Token do
  @moduledoc """
  Represents an Token resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/tokens)
  """

  defstruct username: nil,
            password: nil,
            ttl: nil,
            account_sid: nil,
            ice_servers: nil,
            date_created: nil,
            date_updated: nil

  use ExTwilio.Resource, import: [:stream, :all, :create]

  def parents, do: [:account]
end
