defmodule ExTwilio.ResultStreamTest do
  use ExUnit.Case, async: false
  alias ExTwilio.ResultStream
  import TestHelper

  defmodule Resource do
    defstruct sid: nil, name: nil
    def resource_name, do: "Resources"
    def resource_collection_name, do: "resources"
    def parents, do: []
    def children, do: []
  end

  test ".new returns a new ResultStream" do
    assert is_function(ResultStream.new(Resource))
  end

  test "can return all results" do
    with_streaming_fixture(fn ->
      expected = [%Resource{sid: "1", name: "first"}, %Resource{sid: "2", name: "second"}]
      actual = ResultStream.new(Resource) |> Enum.into([])
      assert actual == expected
    end)
  end

  test "can filter results" do
    with_streaming_fixture(fn ->
      actual =
        ResultStream.new(Resource)
        |> Stream.filter(fn res -> res.name == "second" end)
        |> Enum.take(1)

      assert actual == [%Resource{sid: "2", name: "second"}]
    end)
  end

  test "can map results" do
    with_streaming_fixture(fn ->
      actual =
        ResultStream.new(Resource)
        |> Stream.map(fn res -> res.name end)
        |> Enum.into([])

      assert actual == ["first", "second"]
    end)
  end

  defp with_streaming_fixture(fun) do
    with_fixture(
      {:get!,
       fn url, _headers ->
         if String.match?(url, ~r/\?Page=2/) do
           json_response(page2(), 200)
         else
           json_response(page1(), 200)
         end
       end},
      fun
    )
  end

  defp page1 do
    %{
      "resources" => [
        %{sid: "1", name: "first"}
      ],
      next_page_uri: "?Page=2"
    }
  end

  defp page2 do
    %{
      "resources" => [
        %{sid: "2", name: "second"}
      ],
      next_page_uri: nil
    }
  end
end
