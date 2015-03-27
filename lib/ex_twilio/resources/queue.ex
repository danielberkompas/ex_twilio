defmodule ExTwilio.Queue do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]

  defstruct sid: nil,
            friendly_name: nil,
            current_size: nil,
            max_size: nil,
            average_wait_time: nil
end
