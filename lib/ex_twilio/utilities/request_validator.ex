defmodule ExTwilio.Utilities.RequestValidator do
  @moduledoc """
  Validates that request data is coming from Twilio, based on
  https://www.twilio.com/docs/api/security#validating-requests
  """

  alias ExTwilio.Config

  @doc """
  Validates the URL and parameters generate the correct signature

  ## Example

  Check that a request to a `Plug.Router` endpoint is from Twilio

      uri = %URI{
        scheme: to_string(conn.scheme),
        host: conn.host,
        path: conn.request_path,
        query: if(String.length(conn.query_string) > 0, do: conn.query_string, else: nil)
      } |> URI.to_string
      signature = conn |> get_req_header("x-twilio-signature") |> List.first

      ExTwilio.Utilities.RequestValidator.validate(uri, conn.params, signature)
  """
  @spec validate(String.t, map(), String.t) :: boolean()
  def validate(url, params, remote_signature) do
    build_signature_for(url, params) == remote_signature
  end

  @doc """
  Builds a signature from URL and params map
  """
  @spec build_signature_for(String.t, map()) :: String.t
  def build_signature_for(url, params) do
    sorted_params = sort_map(params)

    "#{url}#{sorted_params}"
    |> sign_string
    |> Base.encode64
    |> String.trim
  end

  @spec sign_string(String.t) :: String.t
  defp sign_string(string), do: :crypto.hmac(:sha, Config.auth_token(), string)

  @spec sort_map(map()) :: String.t
  def sort_map(map) do
    map
    |> Map.to_list
    |> List.keysort(0)
    |> Enum.map_join(fn(elem) -> elem |> Tuple.to_list |> Enum.join("") end)
  end
end
