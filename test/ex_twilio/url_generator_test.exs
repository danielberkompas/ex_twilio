defmodule ExTwilio.UrlGeneratorTest do
  use ExUnit.Case

  defmodule Resource do
    defstruct sid: nil, name: nil
    def resource_name, do: "Resources"
    def resource_collection_name, do: "resources"
  end

  doctest ExTwilio.UrlGenerator
end
