defmodule ExTwilio.UrlGeneratorTest do
  use ExUnit.Case

  import ExTwilio.UrlGenerator

  defmodule Resource do
    defstruct sid: nil, name: nil
    def resource_name, do: "Resources"
    def resource_collection_name, do: "resources"
    def parents, do: [:account, :sip_ip_access_control_list]
    def children, do: [:iso_country_code, :type]
  end

  test "to_query_string can handle a value of type list without error" do
    params = [
      status_callback: "http://example.com/status_callback",
      status_callback_event: ["ringing", "answered", "completed"]
    ]

    assert ExTwilio.UrlGenerator.to_query_string(params) == "StatusCallback=http%3A%2F%2Fexample.com%2Fstatus_callback&StatusCallbackEvent=ringing&StatusCallbackEvent=answered&StatusCallbackEvent=completed"
  end

  doctest ExTwilio.UrlGenerator
end
