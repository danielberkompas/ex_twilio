defmodule ExTwilio.UrlGenerator do
  @moduledoc """
  Generates Twilio URLs for modules. See `build_url/3` for more information.
  """

  alias ExTwilio.Config

  @doc """
  Infers the proper Twilio URL for a resource when given a module, an optional
  SID, and a list of options.

  Note that the module should have the following two functions:

  - `resource_name/0`
  - `resource_collection_name/0`

  # Examples

      iex> ExTwilio.UrlGenerator.build_url(Resource)
      "#{Config.base_url}/Accounts/#{Config.account_sid}/Resources.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, account: 2)
      "#{Config.base_url}/Accounts/2/Resources.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, 1, account: 2)
      "#{Config.base_url}/Accounts/2/Resources/1.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, 1)
      "#{Config.base_url}/Accounts/#{Config.account_sid}/Resources/1.json"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, page: 20)
      "#{Config.base_url}/Accounts/#{Config.account_sid}/Resources.json?Page=20"

      iex> ExTwilio.UrlGenerator.build_url(Resource, nil, iso_country_code: "US", type: "Mobile", page: 20)
      "#{Config.base_url}/Accounts/#{Config.account_sid}/Resources/US/Mobile.json?Page=20"

      iex> ExTwilio.UrlGenerator.build_url(Resource, 1, sip_ip_access_control_list: "list", account: "account_sid")
      "#{Config.base_url}/Accounts/account_sid/SIP/IpAccessControlLists/list/Resources/1.json"
  """
  @spec build_url(atom, String.t | nil, list) :: String.t
  def build_url(module, id \\ nil, options \\ []) do
    url = Config.base_url 

    # Add Account SID segment if not already present
    options = add_account_to_options(module, options)

    # Append parents
    url = url <> build_segments(:parent, module.parents, options)

    # Append module segment
    url = url <> segment(:main, {module.resource_name, id})

    # Append any child segments
    url = url <> build_segments(:child, module.children, options)

    # Append .json
    url = url <> ".json"

    # Append querystring
    if Dict.has_key?(options, :query) do
      url <> options[:query]
    else
      url <> build_query(module, options)
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
    module |> resource_name |> ExTwilio.Utils.underscore
  end

  @spec add_account_to_options(atom, list) :: list
  defp add_account_to_options(module, options) do
    if module == ExTwilio.Account and options[:account] == nil do
      options
    else
      Dict.put_new(options, :account, Config.account_sid)
    end
  end

  @spec build_query(atom, list) :: String.t
  defp build_query(module, options) do
    special = module.parents ++ module.children
    query = Enum.reject(options, fn({key, _val}) -> key in special end)
            |> to_query_string

    if String.length(query) > 0, do: "?" <> query, else: ""
  end

  @spec build_segments(atom, list, list) :: String.t
  defp build_segments(type, allowed_keys, list) do
    for key <- allowed_keys, into: "", do: segment(type, {key, list[key]})
  end

  @spec segment(atom, {atom, any}) :: String.t
  defp segment(type, segment)
  defp segment(type, {_key, nil}) when type in [:parent, :child], do: ""
  defp segment(:child, {_key, value}), do: "/" <> to_string(value)
  defp segment(:main, {key, nil}),     do: "/" <> inflect(key)
  defp segment(type, {key, value}) when type in [:main, :parent] and is_atom(key) do
    "/#{infer_module(key).resource_name}/#{value}"
  end
  defp segment(type, {key, value}) when type in [:main, :parent] and is_binary(key) do
    "/#{inflect(key)}/#{value}"
  end

  @spec inflect(String.t | atom) :: String.t
  defp inflect(string) when is_binary(string), do: string
  defp inflect(atom) when is_atom(atom) do
    atom |> camelize |> Inflex.pluralize
  end

  @spec infer_module(atom) :: atom
  defp infer_module(atom) do
    Module.concat(ExTwilio, camelize(atom))
  end

  @spec camelize(String.t | atom) :: String.t
  defp camelize(name) do
    name |> to_string |> ExTwilio.Utils.camelize
  end
end
