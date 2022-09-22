defmodule ExTwilio.Key do
  @moduledoc """
  Represents an API Key resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/iam/keys/api-key)
  """
  defstruct account_sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            secret: nil,
            sid: nil

  use ExTwilio.Resource,
    import: [
      :find,
      :create,
      :update,
      :destroy
    ]

  def parents, do: [:account]
end
