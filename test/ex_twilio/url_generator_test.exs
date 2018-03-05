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

  defmodule Submodule.Parent do
    defstruct sid: nil, name: nil
    def resource_name, do: "Parents"
    def resource_collection_name, do: "parents"
    def parents, do: [:account]
    def children, do: [:child]
  end

  defmodule Submodule.Child do
    defstruct sid: nil, name: nil
    def resource_name, do: "Children"
    def resource_collection_name, do: "children"
    def parents, do: [:account, %ExTwilio.Parent{module: Submodule.Parent, key: :parent}]
    def children, do: []
  end

  describe "query strings" do
    test "to_query_string can handle a value of type list without error" do
      params = [
        status_callback: "http://example.com/status_callback",
        status_callback_event: ["ringing", "answered", "completed"]
      ]

      assert ExTwilio.UrlGenerator.to_query_string(params) ==
               "StatusCallback=http%3A%2F%2Fexample.com%2Fstatus_callback&StatusCallbackEvent=ringing&StatusCallbackEvent=answered&StatusCallbackEvent=completed"
    end

    test "ignores parent keys at the root module level" do
      options = [account: "1234"]
      refute ExTwilio.UrlGenerator.build_url(Submodule.Child, nil, options) =~ "Account=1234"
    end

    test "ignores parent keys when parent in submodule" do
      options = [parent: "1234"]
      refute ExTwilio.UrlGenerator.build_url(Submodule.Child, nil, options) =~ "Parent=1234"
    end
  end

  describe "building urls for modules with parent in submodule" do
    test "builds a correct url for parent in a submodule" do
      options = [account: 43, parent: 4551]

      assert ExTwilio.UrlGenerator.build_url(Submodule.Child, nil, options) ==
               "https://api.twilio.com/2010-04-01/Accounts/43/Parents/4551/Children.json"
    end
  end

  doctest ExTwilio.UrlGenerator
end
