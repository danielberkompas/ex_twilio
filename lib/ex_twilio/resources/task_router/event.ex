defmodule ExTwilio.TaskRouter.Event do
  @moduledoc """
  Represents the Event logs Twilio keeps track of.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/events)
  """

  defstruct sid: nil,
            description: nil,
            account_sid: nil,
            event_type: nil,
            resource_type: nil,
            resource_sid: nil,
            resource_url: nil,
            event_date: nil,
            source: nil,
            source_ip_address: nil,
            actor_type: nil,
            actor_sid: nil,
            actor_url: nil,
            event_data: nil,
            url: nil

  use ExTwilio.Resource, import: [:stream, :all, :find]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]

  def children,
    do: [
      :minutes,
      :start_date,
      :end_date,
      :event_type,
      :worker_sid,
      :task_queue_sid,
      :workflow_sid,
      :task_sid,
      :reservation_sid
    ]
end
