defmodule ExTwilio.UrlGeneratorTest do
  use ExUnit.Case

  defmodule Resource do
    defstruct sid: nil, name: nil
    def resource_name, do: "Resources"
    def resource_collection_name, do: "resources"
    def parents, do: [:account, :sip_ip_access_control_list]
    def children, do: [:iso_country_code, :type]
  end

  doctest ExTwilio.UrlGenerator
end
