defmodule ExTwilio.Utilities.RequestValidatorPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias ExTwilio.Utilities.RequestValidatorPlug

  @opts RequestValidatorPlug.init([])

  setup do
    happy_request = %{
      params: %{
        CallSid: "CA1234567890ABCDE",
        Caller: "+14158675309",
        Digits: "1234",
        From: "+14158675309",
        To: "+18005551212"
      },
      signature: "XM75rZfHyaqHDotzFKb2zAMEem4="
    }

    sad_request = %{
      params: %{},
      signature: "jgxBS/ESOAtvhrDwbSAK6LenXvQ="
    }

    {:ok, happy_request: happy_request, sad_request: sad_request}
  end

  describe "when valid request" do
    test "allows the request", %{happy_request: request} do
      conn = conn(:post, "/", request[:params])
      |> put_req_header("x-twilio-signature", request[:signature])

      assert RequestValidatorPlug.call(conn, @opts) == conn
    end
  end

  describe "when signature invalid" do
    test "responds unauthorized", %{sad_request: request} do
      conn = conn(:post, "/", request[:params])
      |> put_req_header("x-twilio-signature", request[:signature])
      |> RequestValidatorPlug.call(@opts)

      assert conn.state == :sent
      assert conn.status == 401
    end
  end

  describe "without signature" do
    test "responds unauthorized", %{sad_request: request} do
      conn = conn(:post, "/", request[:params])
      |> RequestValidatorPlug.call(@opts)

      assert conn.state == :sent
      assert conn.status == 401
    end
  end
end
