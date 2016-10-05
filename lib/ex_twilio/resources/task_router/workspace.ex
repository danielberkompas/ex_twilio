defmodule ExTwilio.TaskRouter.Workspace do
  @moduledoc """
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
