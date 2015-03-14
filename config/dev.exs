use Mix.Config

config :ex_twilio, account_sid: System.get_env("TWILIO_ACCOUNT_SID")
config :ex_twilio, auth_token:  System.get_env("TWILIO_AUTH_TOKEN")
