defmodule ExTwilio.Member do
  @moduledoc """
  Represents an Member resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/members)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :update]

  defstruct call_sid: nil,
            date_enqueued: nil,
            wait_time: nil,
            position: nil

  def dequeue(sid, options \\ [])
  def dequeue(%{sid: sid}, options), do: dequeue(sid, options)
  def dequeue(sid, options),         do: update(sid, options)
end
