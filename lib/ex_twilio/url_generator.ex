defmodule ExTwilio.UrlGenerator do
  alias ExTwilio.Config

  @moduledoc """
  Generates Twilio URLs for modules. See `build_url/3` for more information.
  """

  @parents  [:account, :address, :conference, :queue, :message, :call, :recording]
  @children [:iso_country_code, :type]
  @special   @parents ++ @children ++ [:query]

  @doc """
  Infers the proper Twilio URL for a resource when given a module, an optional
  SID, and a list of options.

  Note that the module should have the following two functions:

  - `resource_name/0`
  - `resource_collection_name/0`

  # Examples

      iex> ExTwilio.UrlGenerator.build_url(Resource)
      "#{Config.base_url}Accounts/#{Config.account_sid}/Resources.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, account: 2)
      "#{Config.base_url}Accounts/2/Resources.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, 1, account: 2)
      "#{Config.base_url}Accounts/2/Resources/1.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, 1)
      "#{Config.base_url}Accounts/#{Config.account_sid}/Resources/1.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, page: 20)
      "#{Config.base_url}Accounts/#{Config.account_sid}/Resources.json?Page=20"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, iso_country_code: "US", type: "Mobile", page: 20)
      "#{Config.base_url}Accounts/#{Config.account_sid}/Resources/US/Mobile.json?Page=20"
  """
  @spec build_url(atom, String.t | nil, list) :: String.t
  def build_url(module, id \\ nil, options \\ []) do
    url = Config.base_url 

    # Add Account SID segment if not already present
    options = Dict.put_new(options, :account, Config.account_sid)

    # Append parents
    url = url <> build_segments(@parents, options) <> "/" 

    # Append module segment
    url = url <> segment({module.resource_name, id}, include_nil: true)

    # TODO: Append any child segments
    url = url <> build_segments(@children, options)

    # Append .json
    url = url <> ".json"

    # Append querystring
    if Dict.has_key?(options, :query) do
      url <> options[:query]
    else
      url <> build_query(options)
    end
  end

  @doc """
  Generate a list of querystring parameters for a url from an Elixir list.

  ## Examples

      iex> ExTwilio.UrlGenerator.to_query_string([hello: "world", how_are: "you"])
      "Hello=world&HowAre=you"
  """
  @spec to_query_string(list) :: String.t
  def to_query_string(list) do
    for({key, value} <- list, into: %{}, do: {camelize(key), value})
    |> URI.encode_query
  end

  @doc """
  Converts a module name into a pluralized Twilio-compatible resource name.

  ## Examples

      iex> ExTwilio.UrlGenerator.resource_name(:"Elixir.ExTwilio.Call")
      "Calls"

      # Uses only the last segment of the module name
      iex> ExTwilio.UrlGenerator.resource_name(:"ExTwilio.Resources.Call")
      "Calls"
  """
  @spec resource_name(atom | String.t) :: String.t
  def resource_name(module) do
    name = to_string(module)
    [[name]] = Regex.scan(~r/[a-z]+$/i, name)
    Inflex.pluralize(name)
  end

  @doc """
  Infer a lowercase and underscore collection name for a module.

  ## Examples

      iex> ExTwilio.UrlGenerator.resource_collection_name(Resource)
      "resources"
  """
  @spec resource_collection_name(atom) :: String.t
  def resource_collection_name(module) do
    module |> resource_name |> Mix.Utils.underscore
  end

  @spec build_query(list) :: String.t
  defp build_query(options) do
    query = Enum.reject(options, fn({key, _val}) -> key in @special end)
            |> to_query_string

    if String.length(query) > 0, do: "?" <> query, else: query
  end

  @spec build_segments(list, list) :: String.t
  defp build_segments(allowed_keys, list) do
    for key <- allowed_keys, into: "", do: segment({key, list[key]})
  end

  @spec segment({atom, any}, list) :: String.t
  defp segment(segment, options \\ [])
  defp segment({key, nil}, [include_nil: true]), do: inflect(key)
  defp segment({_key, nil}, _options), do: ""
  defp segment({key, value}, _options) when key in @children, do: "/" <> value
  defp segment({key, value}, _options) do
    "#{inflect(key)}/#{value}"
  end

  @spec inflect(String.t | atom) :: String.t
  defp inflect(string) when is_binary(string), do: string
  defp inflect(atom) when is_atom(atom) do
    atom |> camelize |> Inflex.pluralize
  end

  @spec camelize(String.t | atom) :: String.t
  defp camelize(name) do
    name |> to_string |> Mix.Utils.camelize
  end
end
