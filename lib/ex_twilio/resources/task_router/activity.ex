defmodule ExTwilio.TaskRouter.Activity do
  @moduledoc """
  Represents the current status of your workers. Workers can only have a single activity at a time.

  - [Twilio docs](https://www.twilio.com/docs/api/taskrouter/activities)
  """

  defstruct sid: nil,
            account_sid: nil,
            workspace_sid: nil,
            friendly_name: nil,
            available: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.TaskRouter.Workspace, key: :workspace}]
end
