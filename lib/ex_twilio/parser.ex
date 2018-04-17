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
  @type error :: {:error, String.t(), http_status_code}

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
  @spec parse(HTTPoison.Response.t(), module) :: success | error
  def parse(response, module) do
    handle_errors(response, fn body ->
      Poison.decode!(body, as: target(module))
    end)
  end

  defp target(module) when is_atom(module), do: module.__struct__
  defp target(other), do: other

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
    result =
      handle_errors(response, fn body ->
        as = Map.put(%{}, key, [target(module)])
        Poison.decode!(body, as: as)
      end)

    case result do
      {:ok, list} -> {:ok, list[key], Map.drop(list, [key])}
      error -> error
    end
  end

  # @spec handle_errors(response, ((String.t) -> any)) :: success | success_delete | error
  defp handle_errors(response, fun) do
    case response do
      %{body: body, status_code: status} when status in [200, 201] ->
        {:ok, fun.(body)}

      %{body: _, status_code: 204} ->
        :ok

      %{body: body, status_code: status} ->
        {:ok, json} = Poison.decode(body)
        {:error, json["message"], status}
    end
  end
end
