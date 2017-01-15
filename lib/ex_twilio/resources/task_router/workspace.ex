defmodule ExTwilio.TaskRouter.Workspace do
  @moduledoc """
  A Workspace is a container for your Tasks, Workers, TaskQueues, Workflows and Activities.
  Each of these items exists within a single Workspace and will not be shared across Workspaces.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/workspaces)
  """

  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            event_callback_url: nil,
            default_activity_sid: nil,
            date_created: nil,
            date_updated: nil,
            default_activity_name: nil,
            timeout_activity_sid: nil,
            timeout_activity_name: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def children, do: [:friendly_name]

  def resource_name, do: "Workspaces"
end
