defmodule ExTwilio.Feedback do
  use ExTwilio.Resource, import: [:find, :create]

  defstruct quality_score: nil,
            issue: nil
end
