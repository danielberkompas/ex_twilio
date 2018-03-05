defmodule ExTwilio.TaskRouter.TaskQueueStatistic do
  @moduledoc """
  Realtime and historical statistics for TaskQueues

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/taskqueue-statistics)
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            task_queue_sid: nil

  use ExTwilio.Resource, import: [:stream, :all]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace},
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.TaskQueue, key: :task_queues}
    ]

  def children, do: [:minutes, :friendly_name, :start_date, :end_date]
end
