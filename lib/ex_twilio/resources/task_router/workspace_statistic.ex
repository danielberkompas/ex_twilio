defmodule ExTwilio.TaskRouter.WorkspaceStatistic do
  @moduledoc """
  Provides real time and historical statistics for Workspaces.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/workspace-statistics)
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            workflow_sid: nil

  use ExTwilio.Resource, import: [:stream, :all]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]
  def children, do: [:minutes, :start_date, :end_date]
end
