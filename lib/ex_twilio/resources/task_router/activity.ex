defmodule ExTwilio.TaskRouter.Activity do
  @moduledoc """
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

  def parents, do: [:workspace]
end
