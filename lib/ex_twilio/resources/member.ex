defmodule ExTwilio.Member do
  @moduledoc """
  Represents an Member resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/members)
  """

  defstruct call_sid: nil,
            date_enqueued: nil,
            wait_time: nil,
            position: nil

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :update]

  def parents, do: [:account, :queue]
end
