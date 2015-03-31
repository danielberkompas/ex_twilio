defmodule ExTwilio.Feedback do
  @moduledoc """
  Represents a Call Feedback resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/call-feedback)
  """

  use ExTwilio.Resource, import: [:find, :create]

  defstruct quality_score: nil,
            issue: nil
end
