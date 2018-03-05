defmodule ExTwilio.TaskRouter.Worker do
  @moduledoc """
  Represents a worker resource who preforms tasks.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/workers)
  """

  defstruct sid: nil,
            friendly_name: nil,
            account_sid: nil,
            activity_sid: nil,
            activity_name: nil,
            workspace_sid: nil,
            attributes: nil,
            available: nil,
            date_created: nil,
            date_updated: nil,
            date_status_changed: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]

  def children do
    [
      :friendly_name,
      :target_workers_expression,
      :available,
      :activity_name,
      :activity_sid,
      :task_queue_name,
      :task_queue_sid,
      :date_created,
      :date_updated,
      :date_status_changed
    ]
  end
end
