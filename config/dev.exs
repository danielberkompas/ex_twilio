use Mix.Config

config :ex_twilio, account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
                   auth_token:  System.get_env("TWILIO_AUTH_TOKEN")
