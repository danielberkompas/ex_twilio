defmodule ExTwilio.ApiTest do
  use ExUnit.Case, async: false

  import TestHelper

  alias ExTwilio.Api

  defmodule Resource do
    defstruct sid: nil, name: nil
    def resource_name, do: "Resources"
    def resource_collection_name, do: "resources"
    def parents, do: []
    def children, do: []
  end

  doctest ExTwilio.Api

  test ".find should return the resource if it exists" do
    json = json_response(%{sid: "id"}, 200)

    with_fixture(:get!, json, fn ->
      assert {:ok, %Resource{sid: "id"}} == Api.find(Resource, "id")
      assert {:ok, %Resource{sid: "id"}} == Api.find(Resource, "id", account: "sid")
    end)
  end

  test ".find should return an error from Twilio if the resource does not exist" do
    json = json_response(%{message: "Error message"}, 404)

    with_fixture(:get!, json, fn ->
      assert {:error, %{"message" => "Error message"}, 404} == Api.find(Resource, "id")
    end)
  end

  test ".create should return the resource if successful" do
    json = json_response(%{sid: "id"}, 200)

    with_fixture(:post!, json, fn ->
      assert {:ok, %Resource{sid: "id"}} == Api.create(Resource, field: "value")
      assert {:ok, %Resource{sid: "id"}} == Api.create(Resource, [field: "value"], account: "sid")
    end)
  end

  test ".create should return an error from Twilio if the resource could not be created" do
    json = json_response(%{message: "Resource couldn't be created."}, 500)

    with_fixture(:post!, json, fn ->
      assert {:error, %{"message" => "Resource couldn't be created."}, 500} ==
               Api.create(Resource, field: "value")
    end)
  end

  test ".update should return an updated resource if successful" do
    json = json_response(%{sid: "id", name: "Hello, World!"}, 200)

    with_fixture(:post!, json, fn ->
      name = "Hello, World!"
      expected = {:ok, %Resource{sid: "id", name: name}}
      data = [name: name]

      assert expected == Api.update(Resource, "id", data)
      assert expected == Api.update(Resource, "id", data, account: "sid")
    end)
  end

  test ".update should return an error if unsuccessful" do
    json = json_response(%{message: "The requested resource could not be found."}, 404)

    with_fixture(:post!, json, fn ->
      expected = {:error, %{"message" => "The requested resource could not be found."}, 404}
      assert expected == Api.update(Resource, "nonexistent", name: "Hello, World!")
    end)
  end

  test ".destroy should return :ok if successful" do
    with_fixture(:delete!, %{body: "", status_code: 204}, fn ->
      assert :ok == Api.destroy(Resource, "id")
      assert :ok == Api.destroy(Resource, "id", account: "sid")
    end)
  end

  test ".destroy should return an error if unsuccessful" do
    json = json_response(%{message: "not found"}, 404)

    with_fixture(:delete!, json, fn ->
      assert {:error, %{"message" => "not found"}, 404} == Api.destroy(Resource, "id")
    end)
  end

  test ".auth_header returns no headers by default" do
    assert [] == Api.auth_header([])
  end

  test ".auth_header with account and token options generates an account-level HTTP BASIC Authorization header" do
    account = "AC-testsid"
    token = "test-account-token"
    encoded = Base.encode64("#{account}:#{token}")
    basic_header = "Basic #{encoded}"
    assert [Authorization: basic_header] == Api.auth_header([account: account, token: token])
  end

  test ".auth_header with api_key and api_secret options generates an API key-level HTTP BASIC Authorization header" do
    api_key = "SK-testkey"
    api_secret = "test-api-secret"
    encoded = Base.encode64("#{api_key}:#{api_secret}")
    basic_header = "Basic #{encoded}"
    assert [Authorization: basic_header] == Api.auth_header([api_key: api_key, api_secret: api_secret])
  end

  test ".auth_header with an existing Authorization header retains the existing header" do
    assert [Authorization: "BASIC existing"] == Api.auth_header([Authorization: "BASIC existing"], {"sid", "token"})
  end

  ###
  # HTTPoison API
  ###

  test ".process_request_headers adds the correct headers" do
    headers = Api.process_request_headers([])
    content = {:"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"}
    assert content in headers
    assert Keyword.keys(headers) == [:Authorization, :"Content-Type"]
  end

  test ".process_request_options adds configured options if configured" do
    assert Api.process_request_options([]) == []

    Application.put_env(:ex_twilio, :request_options, hackney: [pool: :mavis])
    assert Api.process_request_options([]) == [hackney: [pool: :mavis]]
    assert Api.process_request_options(bob: :sue) == [bob: :sue, hackney: [pool: :mavis]]
  after
    Application.delete_env(:ex_twilio, :request_options)
  end

  test ".format_data converts data to a query string when passed a list" do
    assert "FieldName=value" == Api.format_data(field_name: "value")
  end

  test ".format_data does not modify the body when passed a not-list" do
    assert "unmodified" == Api.format_data("unmodified")
  end

  ###
  # Helpers
  ###

  def with_list_fixture(fun) do
    data = %{
      "resources" => [
        %{sid: "1", name: "first"},
        %{sid: "2", name: "second"}
      ],
      next_page_uri: "/some/path"
    }

    json = json_response(data, 200)

    with_fixture(:get!, json, fn ->
      expected =
        {:ok,
         [
           %Resource{sid: "1", name: "first"},
           %Resource{sid: "2", name: "second"}
         ], %{"next_page_uri" => "/some/path"}}

      fun.(expected)
    end)
  end
end
