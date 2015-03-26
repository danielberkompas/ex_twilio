defmodule ExTwilio.Call do
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

  use ExTwilio.Resource, import: [:all, :list, :find, :create, :update, :destroy]

  def cancel(sid) when is_binary(sid), do: do_cancel(sid)
  def cancel(%{sid: sid}),             do: do_cancel(sid)
  defp do_cancel(sid), do: update(sid, status: "canceled")

  def complete(sid) when is_binary(sid), do: do_complete(sid)
  def complete(%{sid: sid}),             do: do_complete(sid)
  defp do_complete(sid), do: update(sid, status: "completed")
end
