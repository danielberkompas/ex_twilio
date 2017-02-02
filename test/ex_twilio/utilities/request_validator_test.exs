defmodule ExTwilio.Utilities.RequestValidatorTest do
  use ExUnit.Case, async: true

  alias ExTwilio.Utilities.RequestValidator

  setup do
    url = "https://mycompany.com/myapp.php?foo=1&bar=2"
    params = %{
      CallSid: "CA1234567890ABCDE",
      Caller: "+14158675309",
      Digits: "1234",
      From: "+14158675309",
      To: "+18005551212"
    }
    # The X-Twilio-Signature header attached to the request
    signature = "urDkyRyTqxEy+NHO3igEjVm400k="

    {:ok, url: url, params: params, signature: signature}
  end

  describe "validate/3" do
    test "returns true if signature valid", %{url: url, params: params, signature: signature} do
      assert RequestValidator.validate(url, params, signature)
    end
  end

  describe "build_signature_for/2" do
    test "returns signature for request", %{url: url, params: params, signature: signature} do
      assert RequestValidator.build_signature_for(url, params) == signature
    end
  end
end
