defmodule ExTwilio.TaskRouter.WorkerStatistic do
  @moduledoc """
  TaskRouter provides real time and historical statistics for Workers.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/worker-statistics)
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            worker_sid: nil

  use ExTwilio.Resource, import: [:stream, :all, :find]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace},
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.Worker, key: :workers}
    ]

  def children,
    do: [:minutes, :friendly_name, :start_date, :end_date, :task_queue_name, :task_queue_sid]
end
