defmodule ExTwilio.Member do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :update]

  defstruct call_sid: nil,
            date_enqueued: nil,
            wait_time: nil,
            position: nil

  def dequeue(sid, options \\ [])
  def dequeue(%{sid: sid}, options), do: dequeue(sid, options)
  def dequeue(sid, options),         do: update(sid, options)
end
