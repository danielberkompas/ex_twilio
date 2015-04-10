defmodule ExTwilio.Token do
  @moduledoc """
  Represents an Token resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/tokens)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :create]

  defstruct username: nil,
            password: nil,
            ttl: nil,
            account_sid: nil,
            ice_servers: nil,
            date_created: nil,
            date_updated: nil

  def parents, do: [:account]
end
