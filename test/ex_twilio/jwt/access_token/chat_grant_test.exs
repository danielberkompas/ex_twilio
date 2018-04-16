defmodule ExTwilio.JWT.AccessToken.ChatGrantTest do
  use ExUnit.Case

  alias ExTwilio.JWT.AccessToken.ChatGrant
  alias ExTwilio.JWT.Grant

  describe "__struct__" do
    test "enforces :service_sid" do
      assert_raise ArgumentError, fn ->
        Code.eval_string("%ExTwilio.JWT.AccessToken.ChatGrant{}")
      end

      assert %ChatGrant{service_sid: "sid"}
    end
  end

  describe ".new/1" do
    test "accepts all attributes" do
      assert ChatGrant.new(
               service_sid: "sid",
               endpoint_id: "id",
               deployment_role_sid: "sid",
               push_credential_sid: "sid"
             ) == %ChatGrant{
               service_sid: "sid",
               endpoint_id: "id",
               deployment_role_sid: "sid",
               push_credential_sid: "sid"
             }
    end
  end

  test "implements ExTwilio.JWT.Grant" do
    assert Grant.type(%ChatGrant{service_sid: "sid"}) == "chat"

    assert Grant.attrs(%ChatGrant{service_sid: "sid"}) == %{
             "service_sid" => "sid",
             "endpoint_id" => nil
           }

    assert Grant.attrs(%ChatGrant{service_sid: "sid", deployment_role_sid: "sid"}) == %{
             "service_sid" => "sid",
             "endpoint_id" => nil,
             "deployment_role_sid" => "sid"
           }

    assert Grant.attrs(%ChatGrant{service_sid: "sid", push_credential_sid: "sid"}) == %{
             "service_sid" => "sid",
             "endpoint_id" => nil,
             "push_credential_sid" => "sid"
           }
  end
end
