defmodule ExTwilio.ApiTest do
  use ExUnit.Case, async: false
  alias ExTwilio.Api
  import Mock

  defmodule Resource do
    defstruct sid: nil, name: nil
  end

  doctest ExTwilio.Api

  test ".stream should automatically page through resources, yielding each resource" do
    page1 = %{
      "api_test/resources" => [
        %{sid: "1", name: "first"}, 
      ],
      next_page_uri: "?page=2"
    }

    page2 = %{
      "api_test/resources" => [
        %{sid: "2", name: "second"}, 
      ],
      next_page_uri: nil
    }

    with_fixture {:get, fn "ApiTest.Resources.json?page=2" -> json_response(page2, 200)
                           _url -> json_response(page1, 200)
                        end}, fn ->
      expected = [%Resource{sid: "1", name: "first"}, %Resource{sid: "2", name: "second"}]
      assert expected == Enum.into Api.stream(Resource), []
    end
  end

  test ".list should fetch the first page of results" do
    with_list_fixture fn(expected) ->
      assert expected == Api.list(Resource)
    end
  end

  test ".fetch_page should fetch a page of results, given a page url" do
    with_list_fixture fn(expected) ->
      assert expected == Api.fetch_page(Resource, "next_page_path")
    end
  end

  test ".fetch_page should return an error if passed a nil path" do
    assert {:error, "That page does not exist."} == Api.fetch_page(Resource, nil)
  end

  test ".find should return the resource if it exists" do
    json = json_response(%{sid: "id"}, 200)

    with_fixture :get, json, fn ->
      assert {:ok, %Resource{sid: "id"}} == Api.find(Resource, "id")
      assert called Api.get("ApiTest.Resources/id")
    end
  end

  test ".find should return an error from Twilio if the resource does not exist" do
    json = json_response(%{message: "Error message"}, 404)

    with_fixture :get, json, fn ->
      assert {:error, "Error message", 404} == Api.find(Resource, "id")
    end
  end

  test ".create should return the resource if successful" do
    json = json_response(%{sid: "id"}, 200)

    with_fixture :post, json, fn ->
      assert {:ok, %Resource{sid: "id"}} == Api.create(Resource, [field: "value"])
      assert called Api.post("ApiTest.Resources", body: [field: "value"])
    end
  end

  test ".create should return an error from Twilio if the resource could not be created" do
    json = json_response(%{message: "Resource couldn't be created."}, 500)

    with_fixture :post, json, fn ->
      assert {:error, "Resource couldn't be created.", 500} == Api.create(Resource, [field: "value"])
    end
  end

  test ".update should return an updated resource if successful" do
    json = json_response(%{sid: "id", name: "Hello, World!"}, 200)

    with_fixture :post, json, fn ->
      expected = {:ok, %Resource{sid: "id", name: "Hello, World!"}}
      assert expected == Api.update(Resource, "id", name: "Hello, World!")
      assert called Api.post("ApiTest.Resources/id", body: [name: "Hello, World!"])
    end
  end

  test ".update should return an error if unsuccessful" do
    json = json_response(%{message: "The requested resource could not be found."}, 404)

    with_fixture :post, json, fn ->
      expected = {:error, "The requested resource could not be found.", 404}
      assert expected == Api.update(Resource, "nonexistent", name: "Hello, World!")
    end
  end

  test ".destroy should return :ok if successful" do
    with_fixture :delete, %{body: "", status_code: 204}, fn ->
      assert :ok == Api.destroy(Resource, "id")
      assert called Api.delete("ApiTest.Resources/id")
    end
  end

  test ".destroy should return an error if unsuccessful" do
    json = json_response(%{message: "not found"}, 404)

    with_fixture :delete, json, fn ->
      assert {:error, "not found", 404} == Api.destroy(Resource, "id")
    end
  end

  def with_list_fixture(fun) do
    data = %{
      "api_test/resources" => [
        %{sid: "1", name: "first"}, 
        %{sid: "2", name: "second"}
      ],
      next_page_uri: "/some/path"
    }
    json = json_response(data, 200)

    with_fixture :get, json, fn ->
      expected = {:ok, [
        %Resource{sid: "1", name: "first"},
        %Resource{sid: "2", name: "second"}
      ], %{ "next_page_uri" => "/some/path" }}

      fun.(expected)
    end
  end


  def with_fixture(:get, response, fun),    do: with_fixture({:get,    fn(_url) -> response end}, fun)
  def with_fixture(:post, response, fun),   do: with_fixture({:post,   fn(_url, _options) -> response end}, fun)
  def with_fixture(:delete, response, fun), do: with_fixture({:delete, fn(_url) -> response end}, fun)
  def with_fixture(stub, fun) do
    with_mock Api, [:passthrough], [stub] do
      fun.()
    end
  end

  def json_response(map, status) do
    {:ok, json} = Poison.encode(map)
    %{body: json, status_code: status}
  end
end
