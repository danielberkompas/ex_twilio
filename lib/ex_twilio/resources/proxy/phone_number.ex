defmodule ExTwilio.Proxy.PhoneNumber do
  @moduledoc """
  Represents a Phone Number attached to a Service.

  - [Twilio docs](https://www.twilio.com/docs/proxy/api/phone-number)
  """

  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            date_updated: nil,
            phone_number: nil,
            friendly_name: nil,
            iso_country: nil,
            capabilities: nil,
            url: nil,
            is_reserved: nil,
            in_use: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update, :delete]

  alias ExTwilio.Parser
  alias ExTwilio.Api

  @spec create_reserved(Api.data(), list) :: Parser.success() | Parser.error()
  def create_reserved(data, options) when is_map(data),
    do: data |> Map.to_list() |> create_reserved(options)

  def create_reserved(data, options),
    do: data |> Keyword.merge(is_reserved: true) |> create(options)

  def parents, do: [%ExTwilio.Parent{module: ExTwilio.Proxy.Service, key: :service}]
end
