defmodule ExTwilio.JWT.AccessToken.VoiceGrantTest do
  use ExUnit.Case

  alias ExTwilio.JWT.AccessToken.VoiceGrant
  alias ExTwilio.JWT.Grant

  describe ".new/1" do
    test "accepts all attributes" do
      assert VoiceGrant.new(
               outgoing_application_sid: "outgoing_application_sid",
               outgoing_application_params: %{"key" => "value"},
               incoming_allow: true,
               endpoint_id: "endpoint_id",
               push_credential_sid: "push_credential_sid"
             ) == %VoiceGrant{
               outgoing_application_sid: "outgoing_application_sid",
               outgoing_application_params: %{"key" => "value"},
               incoming_allow: true,
               endpoint_id: "endpoint_id",
               push_credential_sid: "push_credential_sid"
             }
    end
  end

  test "implements ExTwilio.JWT.Grant" do
    assert Grant.type(%VoiceGrant{}) == "voice"

    assert Grant.attrs(%VoiceGrant{
             outgoing_application_sid: "sid",
             outgoing_application_params: %{key: "value"}
           }) == %{
             "outgoing" => %{
               "application_sid" => "sid",
               "params" => %{key: "value"}
             }
           }

    assert Grant.attrs(%VoiceGrant{incoming_allow: true}) == %{
             "incoming" => %{
               "allow" => true
             }
           }

    assert Grant.attrs(%VoiceGrant{endpoint_id: "endpoint_id"}) == %{
             "endpoint_id" => "endpoint_id"
           }

    assert Grant.attrs(%VoiceGrant{push_credential_sid: "push_credential_sid"}) == %{
             "push_credential_sid" => "push_credential_sid"
           }
  end

  test "does not include outgoing_application_params when outgoing_application_sid not defined" do
    assert Grant.attrs(%VoiceGrant{outgoing_application_params: %{key: "value"}}) == %{}
  end
end
