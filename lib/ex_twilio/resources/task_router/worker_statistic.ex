defmodule ExTwilio.TaskRouter.WorkerStatistic do
  @moduledoc """
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            worker_sid: nil

  use ExTwilio.Resource, import: [:stream, :all, :find]

  def parents, do: [:workspace, :workers]
  def children, do: [:minutes, :friendly_name, :start_date, :end_date, :task_queue_name, :task_queue_sid]
end
