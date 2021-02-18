defmodule ExTwilio.Proxy.Participant do
  @moduledoc """
  Represents an Participant attached to a Session.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/participant)
  """

  defstruct sid: nil,
            account_sid: nil,
            session_sid: nil,
            service_sid: nil,
            friendly_name: nil,
            identifier: nil,
            proxy_identifier: nil,
            proxy_identifier_sid: nil,
            date_deleted: nil,
            date_created: nil,
            date_updated: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :delete]

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service},
      %ExTwilio.Parent{module: ExTwilio.Proxy.Session, key: :session}
    ]
end
