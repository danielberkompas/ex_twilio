defmodule ExTwilio.TaskRouter.Event do
  @moduledoc """
  """

  defstruct sid: nil,
            description: nil,
            account_sid: nil,
            event_type: nil,
            resource_type: nil,
            resource_sid: nil,
            resource_url: nil,
            event_date: nil,
            source: nil,
            source_ip_address: nil,
            actor_type: nil,
            actor_sid: nil,
            actor_url: nil,
            event_data: nil,
            url: nil

  use ExTwilio.Resource, import: [:find]

  def parents, do: [:workspace]
end
