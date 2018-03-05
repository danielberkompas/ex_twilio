defmodule ExTwilio.ParserTest do
  use ExUnit.Case
  import ExTwilio.Parser

  defmodule Resource do
    defstruct sid: nil
  end

  doctest ExTwilio.Parser

  test ".parse should decode a successful response into a named struct" do
    response = %{body: "{ \"sid\": \"unique_id\" }", status_code: 200}
    assert {:ok, %Resource{sid: "unique_id"}} == parse(response, Resource)
  end

  test ".parse should return an error when response is 400" do
    response = %{body: "{ \"message\": \"Error message\" }", status_code: 400}
    assert {:error, "Error message", 400} == parse(response, Resource)
  end

  test ".parse should return :ok when response is 204 'No Content'" do
    response = %{body: "", status_code: 204}
    assert :ok == parse(response, Resource)
  end

  test ".parse_list should decode into a list of named structs" do
    json = """
    {
      "resources": [{
        "sid": "first"
      }, {
        "sid": "second"
      }],
      "next_page": 10
    }
    """

    response = %{body: json, status_code: 200}
    expected = [%Resource{sid: "first"}, %Resource{sid: "second"}]
    metadata = %{"next_page" => 10}

    assert {:ok, expected, metadata} == parse_list(response, Resource, "resources")
  end
end
