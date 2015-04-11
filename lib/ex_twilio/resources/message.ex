defmodule ExTwilio.Message do
  @moduledoc """
  Represents an Message resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/messages)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            date_sent: nil,
            account_sid: nil,
            from: nil,
            to: nil,
            body: nil,
            num_media: nil,
            num_segments: nil,
            status: nil,
            error_code: nil,
            error_message: nil,
            direction: nil,
            price: nil,
            price_unit: nil,
            api_version: nil,
            uri: nil,
            subresource_uri: nil

  def parents, do: [:account]
end
