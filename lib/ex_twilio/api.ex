defmodule ExTwilio.Api do
  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the Twilio
  API, by wrapping `HTTPotion`.

  ## Examples

  Requests are made to the Twilio API by passing in a resource module into one
  of this `Api` module's functions. The correct URL to the resource is inferred
  from the module name.

      ExTwilio.Api.find(Resource, "sid")
      %Resource{ sid: "sid", ... }

  Items are returned as instances of the given module's struct. For more
  details, see the documentation for each function.
  """

  use HTTPoison.Base

  alias ExTwilio.Config
  alias ExTwilio.Parser
  alias ExTwilio.UrlGenerator, as: Url
  alias __MODULE__ # Necessary for mocks in tests

  @type data :: map | list | binary

  @doc """
  Find a given resource in the Twilio API by its SID.

  ## Examples

  If the resource was found, `find/2` will return a two-element tuple in this
  format, `{:ok, item}`.

      ExTwilio.Api.find(ExTwilio.Call, "<sid here>")
      {:ok, %Call{ ... }}

  If the resource could not be loaded, `find/2` will return a 3-element tuple
  in this format, `{:error, message, code}`. The `code` is the HTTP status code
  returned by the Twilio API, for example, 404.

      ExTwilio.Api.find(ExTwilio.Call, "nonexistent sid")
      {:error, "The requested resource couldn't be found...", 404}
  """
  @spec find(atom, String.t | nil, list) :: Parser.success | Parser.error
  def find(module, sid, options \\ []) do
    Url.build_url(module, sid, options)
    |> Api.get!
    |> Parser.parse(module)
  end

  @doc """
  Create a new resource in the Twilio API with a POST request.

  ## Examples

      ExTwilio.Api.create(ExTwilio.Call, [to: "1112223333", from: "4445556666"])
      {:ok, %Call{ ... }}

      ExTwilio.Api.create(ExTwilio.Call, [])
      {:error, "No 'To' number is specified", 400}
  """
  @spec create(atom, data, list) :: Parser.success | Parser.error
  def create(module, data, options \\ []) do
    Url.build_url(module, nil, options)
    |> Api.post!(data)
    |> Parser.parse(module)
  end

  @doc """
  Update an existing resource in the Twilio Api.

  ## Examples

      ExTwilio.Api.update(ExTwilio.Call, "<sid>", [status: "canceled"])
      {:ok, %Call{ status: "canceled" ... }}

      ExTwilio.Api.update(ExTwilio.Call, "nonexistent", [status: "complete"])
      {:error, "The requested resource ... was not found", 404}
  """
  @spec update(atom, String.t, data, list) :: Parser.success | Parser.error
  def update(module, sid, data, options \\ [])
  def update(module, sid, data, options) when is_binary(sid), do: do_update(module, sid, data, options)
  def update(module, %{sid: sid}, data, options),             do: do_update(module, sid, data, options)
  defp do_update(module, sid, data, options) do
    Url.build_url(module, sid, options)
    |> Api.post!(data)
    |> Parser.parse(module)
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
    Url.build_url(module, sid, options)
    |> Api.delete!
    |> Parser.parse(module)
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
