defmodule ExTwilio.Api do
  use HTTPotion.Base

  alias ExTwilio.Config
  alias ExTwilio.Parser
  alias __MODULE__ # Necessary for testing/mocking

  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the Twilio
  API, by wrapping `HTTPotion`.
  """

  @doc """
  Seamlessly stream through all available pages of a resource with `stream/2`.
  Pages will be requested lazily, allowing you to start processing as soon as
  the first page of results is returned.

  Page size will affect the number of requests made to Twilio to get the entire
  collection, so it can be configured with the `page_size` option.

  ## Examples

      stream = ExTwilio.Api.stream(ExTwilio.Call, page_size: 1)
      Enum.each stream, fn(call) ->
        IO.puts "We made a call to #\{call.to\}!"
      end

      # Collapse the stream into a list. List will not be returned until all
      # pages have been fetched from Twilio.
      Enum.into stream, []
      [%Call{ ... }, %Call{ ... }, ...]
  """
  @spec stream(module, list) :: Stream.t
  def stream(module, options \\ []) do
    # Start an agent process to store the current page of results from the API.
    # Hydrates the agent with the first page to begin with.
    start = fn ->
      {:ok, items, meta} = list(module, options)
      {:ok, pid} = Agent.start_link(fn -> {items, meta["next_page_uri"], options} end)
      pid
    end

    # Pops the first item off the list currently stored in the agent, and
    # returns head in the format required by Stream.resource for the next_item.
    update_agent = fn agent, list, next, options ->
      [head|tail] = list
      Agent.update(agent, fn _ -> {tail, next, options} end)
      {[head], agent}
    end

    # Hydrate the agent with the next page of results from the API. Used when
    # the agent's list runs dry. If there are no remaining pages, it will halt
    # the stream iteration.
    fetch_next_page = fn agent, module, next_page, options ->
      case fetch_page(module, next_page, options) do
        {:ok, items, meta} -> update_agent.(agent, items, meta["next_page_uri"], options)
        {:error, _msg}     -> {:halt, agent}
      end
    end

    # Fetch the next item for the stream. Halt if there are no more items and no
    # more pages remaining.
    next_item = fn agent ->
      case Agent.get(agent, fn(state) -> state end) do
        {[], nil, _}        -> {:halt, agent}
        {[], next, opts}    -> fetch_next_page.(agent, module, next, opts)
        {items, next, opts} -> update_agent.(agent, items, next, opts)
      end
    end

    # Kill the agent when we are done with it.
    stop = fn agent ->
      Agent.stop(agent)
    end

    Stream.resource(start, next_item, stop)
  end

  @doc """
  Return **all** the resources available for a given Twilio resource.

  **Important**: Since there may be many pages of results, this function has the
  potential to block your process for a long time. Therefore, be _very_ careful.
  Whenever possible, you should use `stream/2` or `list/2`.

  ## Examples

      ExTwilio.Api.all(ExTwilio.Call)
      [%Call{ ... }, %Call{ ... }, ...]
  """
  @spec all(atom) :: list
  def all(module, options \\ []) do
    Enum.into stream(module, options), []
  end

  @doc """
  Get the first page of results for a given resource. Page size is configurable
  with the `page_size` option. For paging through multiple pages, see one of
  these methods:

  - `fetch_page/2`
  - `all/0`
  - `stream/2`

  ## Examples

      {:ok, list, meta} = ExTwilio.Api.list(ExTwilio.Call, page_size: 1)
  """
  def list(module, options \\ []) do
    url = resource_url_with_options(module, options)
    do_list(module, url)
  end

  defp do_list(module, url) do
    resource = module |> resource_name |> Mix.Utils.underscore
    Parser.parse_list(module, Api.get(url), resource)
  end

  @doc """
  Fetch a particular page of results from the API, using a page URL provided by
  Twilio in its page metadata.

  ## Example

      {:ok, list, meta} = ExTwilio.Api.list(ExTwilio.Call)
      {:ok, next_page, meta} = ExTwilio.Api.next_page(ExTwilio.Call, meta["next_page_uri"])
  """
  @spec fetch_page(atom, (String.t | nil), list) :: Parser.success_list | Parser.error
  def fetch_page(module, path, options \\ [])
  def fetch_page(_module, nil, _options), do: {:error, "That page does not exist."}
  def fetch_page(module, path, options) do
    uri = Config.base_url <> path |> String.to_char_list

    case :http_uri.parse(uri) do
      {:ok, {_, _, _, _, _, query}} -> 
        url = account_url_segment(options[:account]) <> resource_name(module) <> ".json" <> String.Chars.to_string(query)
        do_list(module, url)
      {:error, _reason} -> 
        {:error, "Next page URI '#{uri}' was not properly formatted."}
    end
  end

  @doc """
  Find a given resource in the Twilio API by its SID.

  ## Examples

      ExTwilio.Api.find(ExTwilio.Call, "<sid here>")
      {:ok, %Call{ ... }}

      ExTwilio.Api.find(ExTwilio.Call, "nonexistent sid")
      {:error, "The requested resource couldn't be found...", 404}
  """
  @spec find(atom, String.t, list) :: Parser.success | Parser.error
  def find(module, sid, options \\ []) do
    Parser.parse module, Api.get("#{resource_url(module, options)}/#{sid}")
  end

  @doc """
  Create a new resource in the Twilio API.

  ## Examples

      ExTwilio.Api.create(ExTwilio.Call, [to: "1112223333", from: "4445556666"])
      {:ok, %Call{ ... }}

      ExTwilio.Api.create(ExTwilio.Call, [])
      {:error, "No 'To' number is specified", 400}
  """
  @spec create(atom, list, list) :: Parser.success | Parser.error
  def create(module, data, options \\ []) do
    Parser.parse module, Api.post(resource_url(module, options), body: data)
  end

  @doc """
  Update an existing resource in the Twilio Api.

  ## Examples

      ExTwilio.Api.update(ExTwilio.Call, "<sid>", [status: "canceled"])
      {:ok, %Call{ status: "canceled" ... }}

      ExTwilio.Api.update(ExTwilio.Call, "nonexistent", [status: "complete"])
      {:error, "The requested resource ... was not found", 404}
  """
  @spec update(atom, String.t, list, list) :: Parser.success | Parser.error
  def update(module, sid, data, options \\ [])
  def update(module, sid, data, options) when is_binary(sid), do: do_update(module, sid, data, options)
  def update(module, %{sid: sid}, data, options),             do: do_update(module, sid, data, options)
  defp do_update(module, sid, data, options) do
    Parser.parse module, Api.post("#{resource_url(module, options)}/#{sid}", body: data)
  end

  @doc """
  Destroy an existing resource in the Twilio Api.

  ## Examples

      ExTwilio.Api.destroy(ExTwilio.Call, "<sid>")
      :ok

      ExTwilio.Api.destroy(ExTwilio.Call, "nonexistent")
      {:error, "The requested resource ... was not found", 404}
  """
  @spec destroy(atom, String.t) :: Parser.success_delete | Parser.error
  def destroy(module, sid, options \\ [])
  def destroy(module, sid, options) when is_binary(sid), do: do_destroy(module, sid, options)
  def destroy(module, %{sid: sid}, options),             do: do_destroy(module, sid, options)
  defp do_destroy(module, sid, options) do
    Parser.parse module, Api.delete("#{resource_url(module, options)}/#{sid}")
  end

  ###
  # Utilities
  ###

  @doc """
  Takes a module name and options and converts it into a URL segment.

  ## Examples

      iex> ExTwilio.Api.resource_url(Resource)
      "Resources"

      iex> ExTwilio.Api.resource_url(Resource, account: "sid")
      "Accounts/sid/Resources"

      iex> ExTwilio.Api.resource_url(Resource, account: %{sid: "sid"})
      "Accounts/sid/Resources"
  """
  @spec resource_url(atom, list) :: String.t
  def resource_url(module, options \\ []) do
    account_url_segment(options[:account]) <> resource_name(module)
  end

  @doc """
  Converts a module name into a pluralized Twilio-compatible resource name.

  ## Examples

      iex> ExTwilio.Api.resource_name(:"Elixir.ExTwilio.Call")
      "Calls"

      # Uses only the last segment of the module name
      iex> ExTwilio.Api.resource_name(:"ExTwilio.Resources.Call")
      "Calls"
  """
  def resource_name(module) do
    name = to_string(module)
    [[name]] = Regex.scan(~r/[a-z]+$/i, name)
    Inflex.pluralize(name)
  end

  @doc """
  Generate a URL path to a resource from given options.

  ## Examples

      iex> ExTwilio.Api.resource_url_with_options(:"Elixir.ExTwilio.Call", [page: 1])
      "Calls.json?Page=1"
  """
  def resource_url_with_options(module, options) when length(options) > 0 do
     resource_url(module, options) <> ".json?" <> to_querystring(options)
  end
  def resource_url_with_options(module, []), do: resource_name(module)

  @doc """
  Convert a keyword list or map into a query string with CamelCase parameters.

  ## Examples

      iex> ExTwilio.Api.to_querystring([page: 1, page_size: 2])
      "Page=1&PageSize=2"
  """
  def to_querystring(list) do
    list |> reject_protected |> camelize_keys |> URI.encode_query
  end

  @doc """
  Generate a url segment for an account based on an SID.

  ## Examples

      iex> ExTwilio.Api.account_url_segment(nil)
      ""

      iex> ExTwilio.Api.account_url_segment("sid")
      "Accounts/sid/"

      iex> ExTwilio.Api.account_url_segment(%{sid: "sid"})
      "Accounts/sid/"
  """
  def account_url_segment(nil), do: ""
  def account_url_segment(%{sid: sid}), do: account_url_segment(sid)
  def account_url_segment(sid), do: "Accounts/#{sid}/"

  defp camelize_keys(list) do
    list = Enum.map list, fn({key, val}) ->
      key = key |> to_string |> camelize |> String.to_atom
      { key, val }
    end

    Enum.into list, %{}
  end

  defp reject_protected(list) do
    list
    |> List.delete(:account)
    |> List.delete(:account_sid)
  end

  defp camelize(string) do
    String.capitalize(string) |> Inflex.camelize
  end

  ###
  # HTTPotion API
  ###

  @doc """
  Prepends whatever URL is passed into one of the http methods with the
  `Config.base_url`.
  """
  def process_url(url) do
    base = case url =~ ~r/Accounts/ do
      true  -> Config.base_url <> url
      false -> Config.base_url <> "Accounts/#{Config.account_sid}/" <> url
    end

    unless url =~ ~r/\.json/ do
      base = base <> ".json"
    end

    base
  end

  @doc """
  Adds the Account SID and Auth Token to every request through HTTP basic auth.
  """
  def process_options(options) do
    Dict.put(options, :basic_auth, { Config.account_sid, Config.auth_token })
  end

  @doc """
  Automatically add the Content-Type application/x-www-form-urlencoded.
  """
  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
  end

  @doc """
  Correctly format the request body.
  """
  def process_request_body(body) when is_list(body) do
    to_querystring(body)
  end
  def process_request_body(body), do: body
end
