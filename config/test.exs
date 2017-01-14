use Mix.Config

config :ex_twilio, account_sid: {:system, "TWILIO_TEST_ACCOUNT_SID"},
                   auth_token:  {:system, "TWILIO_TEST_AUTH_TOKEN"}
config :logger,
  level: :info
