defmodule ExTwilio.JWT.AccessToken.VideoGrantTest do
  use ExUnit.Case

  alias ExTwilio.JWT.AccessToken.VideoGrant
  alias ExTwilio.JWT.Grant

  describe "__struct__" do
    test "enforces :room" do
      assert_raise ArgumentError, fn ->
        Code.eval_string("%ExTwilio.JWT.AccessToken.VideoGrant{}")
      end

      assert %VideoGrant{room: "room"}
    end
  end

  describe ".new/1" do
    test "accepts all attributes" do
      assert VideoGrant.new(room: "room") == %VideoGrant{
               room: "room"
             }
    end
  end

  test "implements ExTwilio.JWT.Grant" do
    assert Grant.type(%VideoGrant{room: "room"}) == "video"

    assert Grant.attrs(%VideoGrant{room: "room"}) == %{
             "room" => "room"
           }
  end
end
