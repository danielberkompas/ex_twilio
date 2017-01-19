defmodule ExTwilio.TaskRouter.WorkflowStatistic do
  @moduledoc """
  Represents a resource that provides statistics on workflows.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/workflow-statistics)
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            workflow_sid: nil

  use ExTwilio.Resource, import: [:stream, :all]

  def parents, do: [:workspace, :workflow]
  def children, do: [:minutes, :start_date, :end_date]
end
