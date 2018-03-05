defmodule ExTwilio.TaskRouter.TaskQueue do
  @moduledoc """
  TaskQueues are the resource you use to categorize Tasks
  and describe which Workers are eligible to handle those Tasks

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/taskqueues)
  """

  defstruct sid: nil,
            account_sid: nil,
            workspace_sid: nil,
            friendly_name: nil,
            target_workers: nil,
            max_reserverd_workers: nil,
            reservation_activity_sid: nil,
            reservation_activity_name: nil,
            assignment_activity_sid: nil,
            assignment_activity_name: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]

  def children,
    do: [
      :friendly_name,
      :evaluate_worker_attributes,
      :reservation_activity_sid,
      :assignment_activity_sid,
      :target_workers
    ]
end
