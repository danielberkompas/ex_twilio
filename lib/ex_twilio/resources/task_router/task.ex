defmodule ExTwilio.TaskRouter.Task do
  @moduledoc """
  """

  defstruct sid: nil,
            account_sid: nil,
            assignment_status: nil,
            attributes: nil,
            date_created: nil,
            date_status_changed: nil,
            date_updated: nil,
            priority: nil,
            age: nil,
            reason: nil,
            timeout: nil,
            workspace_sid: nil,
            workflow_sid: nil,
            workflow_friendly_name: nil,
            task_queue_sid: nil,
            task_queue_friendly_name: nil,
            url: nil,
            links: nil



  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [:workspace]
  def children, do: [:ordering]
end
