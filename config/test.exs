use Mix.Config

config :ex_twilio, account_sid: System.get_env("TWILIO_TEST_ACCOUNT_SID"),
                   auth_token:  System.get_env("TWILIO_TEST_AUTH_TOKEN"),
                   workspace_sid: System.get_env("TWILIO_TEST_WORKSPACE_SID")
config :logger,
  level: :info
