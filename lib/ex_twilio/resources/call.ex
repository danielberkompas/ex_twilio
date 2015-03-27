defmodule ExTwilio.Call do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]

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

  def cancel(%{sid: sid}), do: cancel(sid)
  def cancel(sid),         do: update(sid, status: "canceled")

  def complete(%{sid: sid}), do: complete(sid)
  def complete(sid),         do: update(sid, status: "completed")
end
