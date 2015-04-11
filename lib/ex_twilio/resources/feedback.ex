defmodule ExTwilio.Feedback do
  @moduledoc """
  Represents a Call Feedback resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/call-feedback)
  """

  defstruct quality_score: nil,
            issue: nil

  use ExTwilio.Resource, import: [:find, :create]

  def parents, do: [:account, :call]
end
