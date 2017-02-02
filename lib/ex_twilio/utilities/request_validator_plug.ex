defmodule ExTwilio.Utilities.RequestValidatorPlug do
  @moduledoc """
  Plug to verify that requests are coming from Twilio using
  `ExTwilio.Utilities.RequestValidator`

  ## Example

  Check that all requests are from Twilio, returning HTTP 401 if not.

      defmodule MyRouter do
        use Plug.Router

        plug ExTwilio.Utilities.RequestValidatorPlug
        plug :match
        plug :dispatch

        # Request has already been validated by the RequestValidatorPlug
        post "/" do
          # ... process call details ...
          # ... build response using ExTwiml ...
          conn
          |> put_resp_header("content-type", "text/xml")
          |> send_resp(200, response)
        end
      end
  """

  import Plug.Conn
  alias ExTwilio.Utilities.RequestValidator

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn |> get_req_header("x-twilio-signature") |> List.first do
      nil -> conn |> send_resp(401, "Not authorized") |> halt
      signature -> conn
                   |> url_from_conn
                   |> RequestValidator.validate(conn.params, signature)
                   |> if(do: conn, else: conn |> send_resp(401, "Not authroized") |> halt)
    end
  end

  defp url_from_conn(conn) do
    %URI{
      scheme: to_string(conn.scheme),
      host: conn.host,
      path: conn.request_path,
      query: if(String.length(conn.query_string) > 0, do: conn.query_string, else: nil)
    }
    |> URI.to_string
  end
end
