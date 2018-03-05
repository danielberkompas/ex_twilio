defmodule ExTwilio.CapabilityTest do
  use ExUnit.Case

  alias ExTwilio.Config

  test ".new sets the TTL to one hour" do
    assert ExTwilio.Capability.new().ttl == 3600
  end

  test ".new sets the start time for the TTL to be the current time" do
    assert_in_delta ExTwilio.Capability.new().start_time, :erlang.system_time(:seconds), 1000
  end

  test ".new sets the account sid from the config" do
    assert ExTwilio.Capability.new().account_sid == Config.account_sid()
  end

  test ".new sets the auth token from the config" do
    assert ExTwilio.Capability.new().auth_token == Config.auth_token()
  end

  test ".allow_client_incoming sets the client name" do
    assert ExTwilio.Capability.allow_client_incoming("tommy").incoming_client_names == ["tommy"]
  end

  test ".allow_client_incoming appends additional client names" do
    capability =
      %ExTwilio.Capability{}
      |> ExTwilio.Capability.allow_client_incoming("tommy")
      |> ExTwilio.Capability.allow_client_incoming("billy")

    assert capability.incoming_client_names == ["tommy", "billy"]
  end

  test ".allow_client_outgoing sets the app sid" do
    assert ExTwilio.Capability.allow_client_outgoing("app_sid").outgoing_client_app ==
             {"app_sid", %{}}
  end

  test ".allow_client_outgoing sets the app sid and params" do
    assert ExTwilio.Capability.allow_client_outgoing("app_sid", %{key: "value"}).outgoing_client_app ==
             {"app_sid", %{key: "value"}}
  end

  test ".allow_client_outgoing overwrites the previous app sid" do
    capability =
      %ExTwilio.Capability{}
      |> ExTwilio.Capability.allow_client_outgoing("app_sid")
      |> ExTwilio.Capability.allow_client_outgoing("not_app_sid")

    assert capability.outgoing_client_app == {"not_app_sid", %{}}
  end

  test ".allow_client_outgoing overwrites the previous app sid and params" do
    capability =
      %ExTwilio.Capability{}
      |> ExTwilio.Capability.allow_client_outgoing("app_sid")
      |> ExTwilio.Capability.allow_client_outgoing("not_app_sid", %{key: "value"})

    assert capability.outgoing_client_app == {"not_app_sid", %{key: "value"}}
  end

  test ".with_ttl sets the ttl" do
    assert ExTwilio.Capability.with_ttl(ExTwilio.Capability.new(), 1000).ttl == 1000
  end

  test ".starting_at sets the start_time" do
    assert ExTwilio.Capability.starting_at(ExTwilio.Capability.new(), 1_464_096_368).start_time ==
             1_464_096_368
  end

  test ".with_account_sid sets the account_sid" do
    assert ExTwilio.Capability.with_account_sid(ExTwilio.Capability.new(), "sid").account_sid ==
             "sid"
  end

  test ".with_auth_token sets the auth_token" do
    assert ExTwilio.Capability.with_auth_token(ExTwilio.Capability.new(), "token").auth_token ==
             "token"
  end

  test ".token sets an expiration time of one hour from now" do
    assert_in_delta decoded_token(ExTwilio.Capability.new()).claims["exp"],
                    :erlang.system_time(:seconds) + 3600,
                    1000
  end

  test ".token sets the issuer to the account sid" do
    assert decoded_token(ExTwilio.Capability.new()).claims["iss"] == Config.account_sid()
  end

  test ".token sets the outgoing scope when no parameters specified" do
    capability =
      ExTwilio.Capability.new()
      |> ExTwilio.Capability.allow_client_outgoing("app sid")

    assert decoded_token(capability).claims["scope"] == "scope:client:outgoing?appSid=app%20sid"
  end

  test ".token sets the outgoing scope when parameters specified" do
    capability =
      ExTwilio.Capability.new()
      |> ExTwilio.Capability.allow_client_outgoing("app sid", %{user_id: "321", xargs_id: "value"})

    assert decoded_token(capability).claims["scope"] ==
             "scope:client:outgoing?appSid=app%20sid&appParams=user_id%3D321%26xargs_id%3Dvalue"
  end

  test ".token sets the incoming scope" do
    capability =
      ExTwilio.Capability.new()
      |> ExTwilio.Capability.allow_client_incoming("tom my")
      |> ExTwilio.Capability.allow_client_incoming("bil ly")

    assert decoded_token(capability).claims["scope"] ==
             "scope:client:incoming?clientName=tom%20my scope:client:incoming?clientName=bil%20ly"
  end

  defp decoded_token(capability) do
    capability
    |> ExTwilio.Capability.token()
    |> Joken.token()
    |> Joken.verify(Joken.hs256(Config.auth_token()))
  end

  doctest ExTwilio.Capability
end
