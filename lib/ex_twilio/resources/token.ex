defmodule ExTwilio.Token do
  use ExTwilio.Resource, import: [:stream, :all, :list, :create]

  defstruct username: nil,
            password: nil,
            ttl: nil,
            account_sid: nil,
            ice_servers: nil,
            date_created: nil,
            date_updated: nil
end
