defmodule ExTwilio.Api do
  use HTTPotion.Base

  alias ExTwilio.Config
  alias ExTwilio.Methods
  alias ExTwilio.Parser

  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the Twilio
  API, by wrapping `HTTPotion`.
  """

  def list(module, options \\ []) do
    url = Methods.resource_url_with_options(module, options)
    do_list(module, url)
  end

  defp do_list(module, url) do
    resource = module |> Methods.resource_name |> Mix.Utils.underscore
    Parser.parse_list(module, get(url), resource)
  end

  def all(module) do
    {:ok, items, meta} = module.list
    do_all(module, items, meta)
  end

  defp do_all(module, items, meta) do
    case fetch_page(module, meta["next_page_uri"]) do
      {:ok, new_items, meta} -> do_all(module, items ++ new_items, meta)
      {:error, _msg}         -> {:ok, items}
    end
  end

  def find(module, sid) do
    Parser.parse module, get("#{Methods.resource_name(module)}/#{sid}")
  end

  def create(module, data) do
    Parser.parse module, post(Methods.resource_name(module), body: data)
  end

  def update(module, sid, data) when is_binary(sid), do: do_update(module, sid, data)
  def update(module, %{sid: sid}, data),             do: do_update(module, sid, data)
  defp do_update(module, sid, data) do
    Parser.parse module, post("#{Methods.resource_name(module)}/#{sid}", body: data)
  end

  def destroy(module, sid) when is_binary(sid), do: do_destroy(module, sid)
  def destroy(module, %{sid: sid}),             do: do_destroy(module, sid)
  defp do_destroy(module, sid) do
    Parser.parse module, Api.delete("#{Methods.resource_name(module)}/#{sid}")
  end

  def fetch_page(_module, nil), do: {:error, "That page does not exist."}
  def fetch_page(module, path) do
    uri = Config.base_url <> path |> String.to_char_list

    case :http_uri.parse(uri) do
      {:ok, {_, _, _, _, _, query}} -> do_list(module, Methods.resource_name(module) <> ".json" <> String.Chars.to_string(query))
      {:error, _reason} -> {:error, "Next page URI was not properly formatted."}
    end
  end

  ###
  # HTTPotion API
  ###

  @doc """
  Prepends whatever URL is passed into one of the http methods with the
  `Config.base_url`.
  """
  def process_url(url) do
    base = Config.base_url <> url

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
    ExTwilio.Methods.to_querystring(body)
  end
  def process_request_body(body), do: body
end
