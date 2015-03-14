defmodule ExTwilio.Api do
  import Mix.Utils, only: [camelize: 1]
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

      if Enum.member? import_functions, :list do
        @doc """
        Retrieve a list of %#{module}{} from the API. 

        ## Examples

            {:ok, list} = #{module}.list
            {:error, msg, http_code} = #{module}.list
        """
        def list do
          parse_list get(resource_name), underscore(resource_name)
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

      defp resource_name do
        __MODULE__
        |> to_string
        |> String.replace(~r/Elixir\.ExTwilio\./, "")
        |> pluralize
      end

      defp pluralize(string) do
        string <> "s"
      end
    end
  end

  @doc """
  Prepends whatever URL is passed into one of the http methods with the
  `Config.base_url`.
  """
  def process_url(url) do
    Config.base_url <> url <> ".json"
  end

  @doc """
  Adds the Account SID and Auth Token to every request through HTTP basic auth.
  """
  def process_options(options) do
    Dict.put(options, :basic_auth, { Config.account_sid, Config.auth_token })
  end

  @doc """
  Automatically add the Content-Type application/x-www-form-urlencoded.

  TODO: make this only apply to POST requests
  """
  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
  end

  @doc """
  Correctly format the request body.
  """
  def process_request_body(body) when is_list(body) do
    body |> camelize_keys |> URI.encode_query
  end
  def process_request_body(body), do: body

  @doc """
  Convert all the keys in a map to CamelCase.
  """
  defp camelize_keys(list) do
    list = Enum.map list, fn({key, val}) ->
      key = key |> to_string |> camelize |> String.to_atom
      { key, val }
    end

    Enum.into list, %{}
  end
end
