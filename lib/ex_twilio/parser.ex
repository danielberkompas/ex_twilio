defmodule ExTwilio.Parser do
  @moduledoc """
  A JSON parser tuned specifically for Twilio API responses. Based on Poison's
  excellent JSON decoder.
  """

  @type metadata :: map
  @type http_status_code :: number
  @type key :: String.t()
  @type success :: {:ok, map}
  @type success_list :: {:ok, [map], metadata}
  @type success_delete :: :ok
  @type error :: {:error, map, http_status_code}

  @type parsed_response :: success | error
  @type parsed_list_response :: success_list | error

  @doc """
  Parse a response expected to contain a single resource. If you pass in a
  module as the first argument, the JSON will be parsed into that module's
  `__struct__`.

  ## Examples

  Given you have a module named `Resource`, defined like this:

      defmodule Resource do
        defstruct sid: nil
      end

  You can parse JSON into that module's struct like so:

      iex> response = %{body: "{ \\"sid\\": \\"AD34123\\" }", status_code: 200}
      ...> ExTwilio.Parser.parse(response, Resource)
      {:ok, %Resource{sid: "AD34123"}}

  You can also parse into a regular map if you want.

      iex> response = %{body: "{ \\"sid\\": \\"AD34123\\" }", status_code: 200}
      ...> ExTwilio.Parser.parse(response, %{})
      {:ok, %{"sid" => "AD34123"}}
  """
  @spec parse(HTTPoison.Response.t(), module) :: success | success_delete | error
  def parse(response, map) when is_map(map) and not :erlang.is_map_key(:__struct__, map) do
    handle_errors(response, fn body -> Jason.decode!(body) end)
  end

  def parse(response, module) do
    handle_errors(response, fn body ->
      struct(module, Jason.decode!(body, keys: :atoms))
    end)
  end

  @doc """
  Parse a response expected to contain multiple resources. If you pass in a
  module as the first argument, the JSON will be parsed into that module's
  `__struct__`.

  ## Examples

  Given you have a module named `Resource`, defined like this:

      defmodule Resource do
        defstruct sid: nil
      end

  And the JSON you are parsing looks like this:

      {
        "resources": [{
          "sid": "first"
        }, {
          "sid": "second"
        }],
        "next_page": 10
      }

  You can parse the the JSON like this:

      ExTwilio.Parser.parse_list(json, Resource, "resources")
      {:ok, [%Resource{sid: "first"}, %Resource{sid: "second"}], %{"next_page" => 10}}
  """
  @spec parse_list(HTTPoison.Response.t(), module, key) :: success_list | error
  def parse_list(response, module, key) do
    case handle_errors(response, fn body -> Jason.decode!(body) end) do
      {:ok, json} -> {:ok, list_to_structs(json[key], module), Map.drop(json, [key])}
      error -> error
    end
  end

  defp list_to_structs(list, module) do
    Enum.map(list, fn item ->
      struct(module, Map.new(item, fn {key, value} -> {String.to_atom(key), value} end))
    end)
  end

  # @spec handle_errors(response, ((String.t) -> any)) :: success | success_delete | error
  defp handle_errors(response, fun) do
    case response do
      %{body: body, status_code: status} when status in [200, 201] ->
        {:ok, fun.(body)}

      %{body: _, status_code: status} when status in [202, 204] ->
        :ok

      %{body: body, status_code: status} ->
        {:error, Jason.decode!(body), status}
    end
  end
end
