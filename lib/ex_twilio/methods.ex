defmodule ExTwilio.Methods do
  import Mix.Utils, only: [camelize: 1]

  @moduledoc """
  Functions split out from the ExTwilio.Api module to make them more testable.
  """

  @doc """
  Converts a module name into a pluralized Twilio-compatible resource name.

  ## Examples

      iex> ExTwilio.Methods.resource_name(:"Elixir.ExTwilio.Call")
      "Calls"
  """
  def resource_name(module) do
    module
    |> to_string
    |> String.replace(~r/Elixir\.ExTwilio\./, "")
    |> pluralize
  end

  @doc """
  Generate a URL path to a resource from given options.

  ## Examples

      iex> ExTwilio.Methods.resource_url_with_options(:"Elixir.ExTwilio.Call", [page: 1])
      "Calls.json?Page=1"
  """
  def resource_url_with_options(module, options) when length(options) > 0 do
    resource_name(module) <> ".json?" <> to_querystring(options)
  end
  def resource_url_with_options(module, []), do: resource_name(module)

  @doc """
  Convert a keyword list or map into a query string with CamelCase parameters.

  ## Examples

      iex> ExTwilio.Methods.to_querystring([page: 1, page_size: 2])
      "Page=1&PageSize=2"
  """
  def to_querystring(list) do
    list |> camelize_keys |> URI.encode_query
  end

  defp camelize_keys(list) do
    list = Enum.map list, fn({key, val}) ->
      key = key |> to_string |> camelize |> String.to_atom
      { key, val }
    end

    Enum.into list, %{}
  end

  defp pluralize(string) do
    string <> "s"
  end
end
