import Config

config :ex_twilio,
  account_sid: {:system, "TWILIO_TEST_ACCOUNT_SID"},
  auth_token: {:system, "TWILIO_TEST_AUTH_TOKEN"},
  workspace_sid: {:system, "TWILIO_TEST_WORKSPACE_SID"}

config :logger, level: :info
