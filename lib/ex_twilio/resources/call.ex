defmodule ExTwilio.Call do
  @moduledoc """
  Represents an Call resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/calls)
  """
  defstruct sid: nil,
            parent_call_sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            to: nil,
            from: nil,
            phone_number_sid: nil,
            status: nil,
            start_time: nil,
            end_time: nil,
            duration: nil,
            price: nil,
            price_unit: nil,
            direction: nil,
            answered_by: nil,
            forwarded_from: nil,
            caller_name: nil,
            uri: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]

  def cancel(%{sid: sid}), do: cancel(sid)
  def cancel(sid), do: update(sid, status: "canceled")

  def complete(%{sid: sid}), do: complete(sid)
  def complete(sid), do: update(sid, status: "completed")

  def parents, do: [:account]
end
