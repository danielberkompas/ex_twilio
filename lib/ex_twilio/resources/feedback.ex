defmodule ExTwilio.Feedback do
  @moduledoc """
  Represents a Call Feedback resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/call-feedback)

  ## Examples

  Since Call Feedback is a nested resource in the Twilio API, you must
  pass in a parent Call SID to all functions in this module.

      ExTwilio.Feedback.create([quality_score: 5], [call: "call_sid"])
      ExTwilio.Feedback.find(call: "call_sid")
  """

  defstruct quality_score: nil,
            issues: nil

  use ExTwilio.Resource, import: [:create]

  @doc """
  Find feedback for a given call. Any options other than `[call: "sid"]` will
  result in a `FunctionClauseError`.

  ## Example

      ExTwilio.Feedback.find(call: "sid")
      %ExTwilio.Feedback{issues: [], quality_score: 5}
  """
  @spec find(call: String.t()) :: Parser.success() | Parser.error()
  def find(call: sid) do
    Api.find(__MODULE__, nil, call: sid)
  end

  def parents, do: [:account, :call]
  def resource_name, do: "Feedback"
end
