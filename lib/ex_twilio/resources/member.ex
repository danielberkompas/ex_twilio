defmodule ExTwilio.Member do
  @moduledoc """
  Represents an Member resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/chat/rest/member-resource)

  ## Examples

  Since Members are members of a Queue in the Twilio API, you must pass a Queue
  SID into each function in this module.

      ExTwilio.Member.all(queue: "queue_sid")

  """

  defstruct call_sid: nil,
            date_enqueued: nil,
            wait_time: nil,
            position: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update]

  def parents, do: [:account, :queue]

  def resource_collection_name, do: Url.resource_collection_name(ExTwilio.QueueMember)
end
