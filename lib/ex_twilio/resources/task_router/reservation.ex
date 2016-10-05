defmodule ExTwilio.TaskRouter.Reservation do
  @moduledoc """
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

  def parents, do: [:workspace, :task]
end
