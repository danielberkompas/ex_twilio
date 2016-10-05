defmodule ExTwilio.TaskRouter.WorkspaceStatistic do
  @moduledoc """
  """

  defstruct realtime: nil,
            cumulative: nil,
            account_sid: nil,
            workspace_sid: nil,
            workflow_sid: nil

  use ExTwilio.Resource, import: [:stream, :all]

  def parents, do: [:workspace]
  def children, do: [:minutes, :start_date, :end_date]
end
