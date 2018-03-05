defmodule ExTwilio.TaskRouter.Reservation do
  @moduledoc """
  TaskRouter creates a Reservation subresource whenever a Task is reserved for a a Worker.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/reservations)
  """

  defstruct sid: nil,
            account_sid: nil,
            workspace_sid: nil,
            task_sid: nil,
            worker_sid: nil,
            worker_name: nil,
            resevation_status: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :update]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace},
      %ExTwilio.Parent{module: ExTwilio.TaskRouter.Task, key: :task}
    ]

  def children, do: [:worker_sid, :reservation_status]
end
