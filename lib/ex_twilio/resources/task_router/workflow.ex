defmodule ExTwilio.TaskRouter.Workflow do
  @moduledoc """
  Represents a workflow that controls how tasks will be prioritized and routed into queues.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/workflows)
  """

  defstruct sid: nil,
            friendly_name: nil,
            account_sid: nil,
            workspace_sid: nil,
            assignment_callback_url: nil,
            fallback_assignment_callback_url: nil,
            document_content_type: nil,
            configuration: nil,
            task_reservation_timeout: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]
  def children, do: [:friendly_name, :configuration]
end
