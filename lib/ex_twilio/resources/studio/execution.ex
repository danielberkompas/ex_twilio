defmodule ExTwilio.Studio.Execution do
  @moduledoc """
  Represents a specific person's run through a Flow.
  An execution is active while the user is in the Flow, and it is considered ended when they stop or are kicked out of the Flow.

  - [Twilio docs](https://www.twilio.com/docs/studio/rest-api/execution)
  """

  defstruct [
    :sid,
    :account_sid,
    :flow_sid,
    :context,
    :contact_sid,
    :status,
    :date_created,
    :date_updated,
    :url
  ]

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :delete]

  def parents,
    do: [%ExTwilio.Parent{module: ExTwilio.Studio.Flow, key: :flow}]

  def children, do: [:execution_context, :steps]
end
