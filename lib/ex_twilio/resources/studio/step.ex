defmodule ExTwilio.Studio.Step do
  @moduledoc """
  A Step is the runtime processing of a Widget, starting when that Widget is entered.
  Variables get set at the end of a Step.

  - [Twilio docs](https://www.twilio.com/docs/studio/rest-api/step)
  """

  defstruct [
    :sid,
    :account_sid,
    :execution_sid,
    :name,
    :context,
    :transitioned_from,
    :transitioned_to,
    :date_created,
    :date_updated,
    :url
  ]

  use ExTwilio.Resource, import: [:stream, :all, :find]

  def parents do
    [
      %ExTwilio.Parent{module: ExTwilio.Studio.Flow, key: :flow},
      %ExTwilio.Parent{module: ExTwilio.Studio.Execution, key: :execution}
    ]
  end

  def children, do: [:context]
end
