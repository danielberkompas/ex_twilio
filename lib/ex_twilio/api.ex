defmodule ExTwilio.Api do
  use HTTPotion.Base

  alias ExTwilio.Config

  @moduledoc """
  Provides a basic HTTP interface to allow easy communication with the Twilio
  API, by wrapping `HTTPotion`.
  """

  @doc """
  Provide a `use` macro for use extending.
  """
  defmacro __using__(options) do
    import_functions  = options[:import] || []
    quote bind_quoted: [import_functions: import_functions] do
      use ExTwilio.Parser
      import ExTwilio.Api
      import Mix.Utils, only: [underscore: 1]

      module = String.replace(to_string(__MODULE__), ~r/Elixir\./, "")

      if Enum.member? import_functions, :all do
        def all do
          {:ok, items, meta} = __MODULE__.list
          do_all(items, meta)
        end

        defp do_all(items, meta) do
          case __MODULE__.next_page(meta) do
            {:ok, new_items, meta} -> do_all(items ++ new_items, meta)
            {:error, _msg}         -> {:ok, items}
          end
        end
      end

      if Enum.member? import_functions, :list do
        @doc """
        Retrieve a list of %#{module}{} from the API. 

        ## Examples

            {:ok, list, metadata} = #{module}.list
            {:error, msg, http_code} = #{module}.list
        """
        def list(options \\ []) do
          url = ExTwilio.Methods.resource_url_with_options(__MODULE__, options)
          do_list(url)
        end
        defp do_list(url), do: parse_list(get(url), underscore(resource_name))

        def next_page(metadata) do
          fetch_page(metadata["next_page_uri"])
        end

        def previous_page(metadata) do
          fetch_page(metadata["previous_page_uri"])
        end

        def first_page(metadata) do
          fetch_page(metadata["first_page_uri"])
        end

        def last_page(metadata) do
          fetch_page(metadata["last_page_uri"])
        end

        def fetch_page(nil), do: {:error, "That page does not exist."}
        def fetch_page(path) do
          uri = Config.base_url <> path |> String.to_char_list

          case :http_uri.parse(uri) do
            {:ok, {_, _, _, _, _, query}} -> do_list(resource_name <> ".json" <> String.Chars.to_string(query))
            {:error, reason} -> {:error, "Next page URI was not properly formatted."}
          end
        end
      end

      if Enum.member? import_functions, :find do
        @doc """
        Find an %#{module}{} by its Twilio SID.

        ## Examples

            {:ok, item} = #{module}.find("...")
            {:error, msg, http_status} = #{module}.find("...")
        """
        def find(sid) do
          parse get("#{resource_name}/#{sid}")
        end
      end

      if Enum.member? import_functions, :create do
        @doc """
        Create a new %#{module}{} in the Twilio API. Any option supported by this
        Resource can be passed in the 'data' keyword list. See Twilio's 
        documentation for this resource for more details.
        """
        def create(data) do
          parse post(resource_name, body: data)
        end
      end

      if Enum.member? import_functions, :update do
        @doc """
        Update an %#{module}{} in the Twilio API. You can pass it a binary SID as
        the identifier, or a whole %#{module}{}.

        ## Examples

            {:ok, item} = #{module}.update(%#{module}{...}, field: "new_value")
            {:ok, item} = #{module}.update("<SID HERE>", field: "new_value")
        """
        def update(sid, data) when is_binary(sid), do: do_update(sid, data)
        def update(%{sid: sid}, data),             do: do_update(sid, data)
        defp do_update(sid, data) do
          parse post("#{resource_name}/#{sid}", body: data)
        end
      end

      if Enum.member? import_functions, :destroy do
        @doc """
        Delete a %#{module}{} from your Twilio account.
        """
        def destroy(sid) when is_binary(sid), do: do_destroy(sid)
        def destroy(%{sid: sid}),             do: do_destroy(sid)
        defp do_destroy(sid) do
          parse delete("#{resource_name}/#{sid}")
        end
      end

      defp resource_name, do: ExTwilio.Methods.resource_name(__MODULE__)
    end
  end

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
