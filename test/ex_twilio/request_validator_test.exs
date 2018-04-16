defmodule ExTwilio.RequestValidatorTest do
  alias ExTwilio.RequestValidator

  use ExUnit.Case, async: true

  describe "validating a voice request" do
    setup do
      params = %{
        "ToState" => "California",
        "CalledState" => "California",
        "Direction" => "inbound",
        "FromState" => "CA",
        "AccountSid" => "ACba8bc05eacf94afdae398e642c9cc32d",
        "Caller" => "+14153595711",
        "CallerZip" => "94108",
        "CallerCountry" => "US",
        "From" => "+14153595711",
        "FromCity" => "SAN FRANCISCO",
        "CallerCity" => "SAN FRANCISCO",
        "To" => "+14157669926",
        "FromZip" => "94108",
        "FromCountry" => "US",
        "ToCity" => "",
        "CallStatus" => "ringing",
        "CalledCity" => "",
        "CallerState" => "CA",
        "CalledZip" => "",
        "ToZip" => "",
        "ToCountry" => "US",
        "CallSid" => "CA136d09cd59a3c0ec8dbff44da5c03f31",
        "CalledCountry" => "US",
        "Called" => "+14157669926",
        "ApiVersion" => "2010-04-01",
        "ApplicationSid" => "AP44efecad51364e80b133bb7c07eb8204"
      }

      {:ok,
       [
         params: params,
         signature: "oVb2kXoVy8GEfwBDjR8bk/ZZ6eA=",
         token: "2bd9e9638872de601313dc77410d3b23",
         url: "http://twiliotests.heroku.com/validate/voice"
       ]}
    end

    test "validating a correct voice request", context do
      assert(
        RequestValidator.valid?(
          context[:url],
          context[:params],
          context[:signature],
          context[:token]
        )
      )
    end

    test "validating an incorrect voice request", context do
      refute(
        RequestValidator.valid?(
          context[:url],
          context[:params],
          "incorrect",
          context[:token]
        )
      )
    end
  end

  describe "validating a text request" do
    setup do
      params = %{
        "ToState" => "CA",
        "FromState" => "CA",
        "AccountSid" => "ACba8bc05eacf94afdae398e642c9cc32d",
        "SmsMessageSid" => "SM2003cbd5e6a3701999aa3e5f20ff2787",
        "Body" => "Orly",
        "From" => "+14159354345",
        "FromCity" => "SAN FRANCISCO",
        "SmsStatus" => "received",
        "FromZip" => "94107",
        "FromCountry" => "US",
        "To" => "+14158141819",
        "ToCity" => "SAN FRANCISCO",
        "ToZip" => "94105",
        "ToCountry" => "US",
        "ApiVersion" => "2010-04-01",
        "SmsSid" => "SM2003cbd5e6a3701999aa3e5f20ff2787"
      }

      {:ok,
       [
         params: params,
         signature: "mxeiv65lEe0b8L6LdVw2jgJi8yw=",
         token: "2bd9e9638872de601313dc77410d3b23",
         url: "http://twiliotests.heroku.com/validate/sms"
       ]}
    end

    test "validating a correct sms request", context do
      assert(
        RequestValidator.valid?(
          context[:url],
          context[:params],
          context[:signature],
          context[:token]
        )
      )
    end

    test "validating an incorrect sms request", context do
      refute(
        RequestValidator.valid?(
          context[:url],
          context[:params],
          "incorrect",
          context[:token]
        )
      )
    end
  end
end
