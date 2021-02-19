defmodule ExTwilio.Proxy.ShortCode do
  @moduledoc """
  Represents a Short Code attached to a Service.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/short-code)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            date_updated: nil,
            short_code: nil,
            iso_country: nil,
            capabilities: nil,
            url: nil,
            is_reserved: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service}]
end
