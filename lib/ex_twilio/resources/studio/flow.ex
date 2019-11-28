defmodule ExTwilio.Studio.Flow do
  @moduledoc """
  Represents an individual workflow that you create.
  They can handle one or more use cases.

  - [Twilio docs](https://www.twilio.com/docs/studio/rest-api/flow)
  """

  defstruct [
    :sid,
    :account_sid,
    :friendly_name,
    :status,
    :version,
    :date_created,
    :date_updated,
    :url
  ]

  use ExTwilio.Resource, import: [:stream, :all, :find, :delete]

  def children, do: [:engagements, :executions]
end
