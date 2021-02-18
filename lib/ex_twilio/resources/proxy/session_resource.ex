defmodule ExTwilio.Proxy.SessionResource do
  @moduledoc """
  Represents an allocated Session containing Participants, an allocated Phone Number, and Interations.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/session)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_started: nil,
            date_ended: nil,
            date_last_interation: nil,
            date_expirty: nil,
            unique_name: nil,
            status: nil,
            closed_reason: nil,
            ttl: nil,
            mode: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service}]

  def resource_name, do: "Sessions"
end
