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
  # Necessary for mocks in tests
  alias __MODULE__

  @type data :: map | list

  @doc """
  Find a given resource in the Twilio API by its SID.

  ## Examples

  If the resource was found, `find/2` will return a two-element tuple in this
  format, `{:ok, item}`.

      ExTwilio.Api.find(ExTwilio.Call, "<sid here>")
      {:ok, %Call{ ... }}

  If the resource could not be loaded, `find/2` will return a 3-element tuple
  in this format, `{:error, error_body, code}`. The `code` is the HTTP status code
  returned by the Twilio API, for example, 404.

      ExTwilio.Api.find(ExTwilio.Call, "nonexistent sid")
      {:error, %{"message" => The requested resource couldn't be found..."}, 404}

  """
  @spec find(atom, String.t() | nil, list) :: Parser.success() | Parser.error()
  def find(module, sid, options \\ []) do
    module
    |> Url.build_url(sid, options)
    |> Api.get!(auth_header(options))
    |> Parser.parse(module)
  end

  @doc """
  Create a new resource in the Twilio API with a POST request.

  ## Examples

      ExTwilio.Api.create(ExTwilio.Call, [to: "1112223333", from: "4445556666"])
      {:ok, %Call{ ... }}

      ExTwilio.Api.create(ExTwilio.Call, [])
      {:error, %{"message" => "No 'To' number is specified"}, 400}

  """
  @spec create(atom, data, list) :: Parser.success() | Parser.error()
  def create(module, data, options \\ []) do
    data = format_data(data)

    module
    |> Url.build_url(nil, options)
    |> Api.post!(data, auth_header(options))
    |> Parser.parse(module)
  end

  @doc """
  Update an existing resource in the Twilio Api.

  ## Examples

      ExTwilio.Api.update(ExTwilio.Call, "<sid>", [status: "canceled"])
      {:ok, %Call{ status: "canceled" ... }}

      ExTwilio.Api.update(ExTwilio.Call, "nonexistent", [status: "complete"])
      {:error, %{"message" => "The requested resource ... was not found"}, 404}

  """
  @spec update(atom, String.t(), data, list) :: Parser.success() | Parser.error()
  def update(module, sid, data, options \\ [])

  def update(module, sid, data, options) when is_binary(sid),
    do: do_update(module, sid, data, options)

  def update(module, %{sid: sid}, data, options), do: do_update(module, sid, data, options)

  defp do_update(module, sid, data, options) do
    data = format_data(data)

    module
    |> Url.build_url(sid, options)
    |> Api.post!(data, auth_header(options))
    |> Parser.parse(module)
  end

  @doc """
  Destroy an existing resource in the Twilio Api.

  ## Examples

      ExTwilio.Api.destroy(ExTwilio.Call, "<sid>")
      :ok

      ExTwilio.Api.destroy(ExTwilio.Call, "nonexistent")
      {:error, %{"message" => The requested resource ... was not found"}, 404}

  """
  @spec destroy(atom, String.t()) :: Parser.success_delete() | Parser.error()
  def destroy(module, sid, options \\ [])
  def destroy(module, sid, options) when is_binary(sid), do: do_destroy(module, sid, options)
  def destroy(module, %{sid: sid}, options), do: do_destroy(module, sid, options)

  defp do_destroy(module, sid, options) do
    module
    |> Url.build_url(sid, options)
    |> Api.delete!(auth_header(options))
    |> Parser.parse(module)
  end

  @doc """
  Builds custom auth header for subaccounts.

  ## Examples
    iex> ExTwilio.Api.auth_header([account: 123, token: 123])
    ["Authorization": "Basic MTIzOjEyMw=="]

    iex> ExTwilio.Api.auth_header([], {nil, 2})
    []

  """
  @spec auth_header(options :: list) :: list
  def auth_header(options \\ []) do
    auth_header([], {options[:account], options[:token]})
  end

  @doc """
  Builds custom auth header for subaccounts.

  Handles master account case if :"Authorization" custom header isn't present

  ## Examples

    iex> ExTwilio.Api.auth_header([], {123, 123})
    ["Authorization": "Basic MTIzOjEyMw=="]

    iex> ExTwilio.Api.auth_header(["Authorization": "Basic BASE64=="], {123, 123})
    ["Authorization": "Basic BASE64=="]

  """
  @spec auth_header(headers :: list, auth :: tuple) :: list
  def auth_header(headers, {sid, token}) when not is_nil(sid) and not is_nil(token) do
    case Keyword.has_key?(headers, :Authorization) do
      true ->
        headers

      false ->
        auth = Base.encode64("#{sid}:#{token}")

        headers
        |> Keyword.put(:Authorization, "Basic #{auth}")
    end
  end

  def auth_header(headers, _), do: headers

  @spec format_data(any) :: binary
  def format_data(data)

  def format_data(data) when is_map(data) do
    data
    |> Map.to_list()
    |> Url.to_query_string()
  end

  def format_data(data) when is_list(data) do
    Url.to_query_string(data)
  end

  def format_data(data), do: data

  ###
  # HTTPotion API
  ###

  def process_request_headers(headers \\ []) do
    headers
    |> Keyword.put(:"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
    |> auth_header({Config.account_sid(), Config.auth_token()})
  end

  def process_request_options(options) do
    Keyword.merge(options, Config.request_options())
  end
end
