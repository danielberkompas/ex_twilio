defmodule ExTwilio.JWT.AccessTokenTest do
  use ExUnit.Case, async: true

  alias ExTwilio.JWT.AccessToken

  describe ".new/1" do
    test "accepts all struct keys" do
      assert AccessToken.new(
               token_identifier: "id",
               account_sid: "sid",
               api_key: "sid",
               api_secret: "secret",
               identity: "user@email.com",
               grants: [
                 AccessToken.ChatGrant.new(service_sid: "sid"),
                 AccessToken.VideoGrant.new(room: "room")
               ],
               expires_in: 86_400
             ) == %AccessToken{
               token_identifier: "id",
               account_sid: "sid",
               api_key: "sid",
               api_secret: "secret",
               identity: "user@email.com",
               grants: [
                 %AccessToken.ChatGrant{service_sid: "sid"},
                 %AccessToken.VideoGrant{room: "room"}
               ],
               expires_in: 86_400
             }
    end
  end

  describe ".to_jwt!/1" do
    test "produces a valid Twilio JWT" do
      token =
        AccessToken.new(
          account_sid: "sid",
          api_key: "sid",
          api_secret: "secret",
          identity: "user@email.com",
          grants: [
            AccessToken.ChatGrant.new(service_sid: "sid"),
            AccessToken.VideoGrant.new(room: "room"),
            AccessToken.VoiceGrant.new(
              outgoing_application_sid: "sid",
              outgoing_application_params: %{key: "value"}
            )
          ],
          expires_in: 86_400
        )
        |> AccessToken.to_jwt!()

      signer = Joken.Signer.create("HS256", "secret")

      assert {:ok, claims} = Joken.verify(token, signer)
      assert claims["iss"] == "sid"
      assert claims["sub"] == "sid"
      assert_in_delta unix_now(), claims["iat"], 10
      assert_in_delta unix_now(), claims["nbf"], 10
      assert_in_delta unix_now(), claims["exp"], 86_400

      assert claims["grants"] == %{
               "chat" => %{"service_sid" => "sid"},
               "video" => %{"room" => "room"},
               "voice" => %{
                 "outgoing" => %{"application_sid" => "sid", "params" => %{"key" => "value"}}
               },
               "identity" => "user@email.com"
             }
    end

    test "validates binary keys" do
      for invalid <- [123, ~c"sid", nil, false],
          field <- [:account_sid, :api_key, :api_secret, :identity] do
        assert_raise ArgumentError, fn ->
          [{field, invalid}]
          |> AccessToken.new()
          |> AccessToken.to_jwt!()
        end
      end
    end

    test "validates :grants" do
      assert_raise ArgumentError, fn ->
        [grants: [%{}]]
        |> AccessToken.new()
        |> AccessToken.to_jwt!()
      end
    end

    test "validates :expires_in" do
      for invalid <- [nil, false, "1 hour"] do
        assert_raise ArgumentError, fn ->
          [expires_in: invalid]
          |> AccessToken.new()
          |> AccessToken.to_jwt!()
        end
      end
    end
  end

  defp unix_now do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
