defmodule ExTwilio.Video.Room do
  @moduledoc """
  Represents a programmable video Room.

  - [Twilio docs](https://www.twilio.com/docs/video/api/rooms-resource)
  """

  defstruct [
    :sid,
    :account_sid,
    :date_created,
    :date_updated,
    :unique_name,
    :status,
    :status_callback,
    :status_callback_method,
    :end_time,
    :duration,
    :type,
    :max_participants,
    :record_participant_on_connect,
    :video_codecs,
    :media_region,
    :url,
    :links
  ]

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update
    ]

  def complete(%{sid: sid}), do: complete(sid)
  def complete(sid), do: update(sid, status: "completed")

  def parents, do: [:account]
end
