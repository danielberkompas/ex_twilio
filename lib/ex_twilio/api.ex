defmodule ExTwilio.Api do
  use HTTPotion.Base

  alias ExTwilio.Config
  alias ExTwilio.Parser
  alias ExTwilio.UrlGenerator, as: Url
  alias __MODULE__ # Necessary for mocks in tests

  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the Twilio
  API, by wrapping `HTTPotion`.

  ## Examples

  Requests are made to the Twilio API by passing in a resource module into one
  of this `Api` module's many functions. The correct URL to the resource is
  inferred from the module name.

      ExTwilio.Api.all(Resource)
      [%Resource{ ... }, %Resource{ ... }]

  Items are returned as instances of the given module's struct. For more
  details, see the documentation for each function.
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

      # Progressively build filters with the Pipe operator.
      ExTwilio.Api.stream(ExTwilio.Call)
      |> Stream.filter fn(call) -> call.duration > 120 end
      |> Stream.map    fn(call) -> call.sid end
      |> Enum.into [] # Only here is the stream actually executed
  """
  @spec stream(module, list) :: Enumerable.t
  def stream(module, options \\ []) do
    start = fn ->
      case list(module, options) do
        {:ok, items, meta} -> {items, meta["next_page_uri"], options}
        _                  -> {[], nil, []}
      end
    end

    pop_item = fn {[head|tail], next, options} ->
      new_state = {tail, next, options}
      {[head], new_state}
    end

    fetch_next_page = fn module, state = {[], next_page, options} ->
      case fetch_page(module, next_page, options) do
        {:ok, items, meta} -> pop_item.({items, meta["next_page_uri"], options})
        _error             -> {:halt, state}
      end
    end

    next_item = fn state = {[], nil, _}       -> {:halt, state}
                   state = {[], _next, _opts} -> fetch_next_page.(module, state)
                   state                      -> pop_item.(state)
    end

    stop = fn (_) -> end

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

  If you want the function to take less time, you can increase the size of the
  pages returned by Twilio. This will reduce the number of requests.

      ExTwilio.Api.all(ExTwilio.Call, page_size: 100)
  """
  @spec all(atom, list) :: [map]
  def all(module, options \\ []) do
    Enum.into stream(module, options), []
  end

  @doc """
  Get the first page of results for a given resource. Page size is configurable
  with the `page_size` option. For paging through multiple pages, see one of
  these functions:

  - `fetch_page/2`
  - `all/0`
  - `stream/2`

  ## Examples

      {:ok, list, meta} = ExTwilio.Api.list(ExTwilio.Call, page_size: 1)
  """
  @spec list(atom, list) :: Parser.success_list | Parser.error
  def list(module, options \\ []) do
    url = Url.build_url(module, nil, options)
    do_list(module, url)
  end

  @spec do_list(module, String.t) :: Parser.success_list | Parser.error
  defp do_list(module, url) do
    Parser.parse_list(module, Api.get(url), module.resource_collection_name)
  end

  @doc """
  Fetch a particular page of results from the API, using a page URL provided by
  Twilio in its pagination metadata.

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
        url = Url.build_url(module, nil, Dict.put(options, :query, String.Chars.to_string(query)))
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
    Parser.parse module, Api.get(Url.build_url(module, sid, options))
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
    Parser.parse module, Api.post(Url.build_url(module, nil, options), body: data)
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
    Parser.parse module, Api.post(Url.build_url(module, sid, options), body: data)
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
    Parser.parse module, Api.delete(Url.build_url(module, sid, options))
  end

  ###
  # HTTPotion API
  ###

  @doc """
  Adds the Account SID and Auth Token to every request through HTTP basic auth.

  ## Example

      iex> ExTwilio.Api.process_options([])
      [basic_auth: { #{inspect Config.account_sid}, #{inspect Config.auth_token} }]
  """
  @spec process_options(list) :: list
  def process_options(options) do
    Dict.put(options, :basic_auth, { Config.account_sid, Config.auth_token })
  end

  @doc """
  Automatically add the Content-Type application/x-www-form-urlencoded. This 
  allows POST request data to be processed properly. It seems to have no
  negative effect on GET calls, so it is added to all requests.

  ## Example

      iex> ExTwilio.Api.process_request_headers([])
      [{:"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"}]
  """
  @spec process_request_headers(list) :: list
  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
  end

  @doc """
  If the request body is a list, then convert the list to a query string. 
  Otherwise, pass it through unmodified.

  ## Examples

      iex> ExTwilio.Api.process_request_body([hello: "world"])
      "Hello=world"

      iex> ExTwilio.Api.process_request_body("Hello, world!")
      "Hello, world!"
  """
  def process_request_body(body) when is_list(body) do
    Url.to_query_string(body)
  end
  def process_request_body(body), do: body
end
