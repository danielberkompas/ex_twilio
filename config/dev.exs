use Mix.Config

config :ex_twilio,
  account_sid: {:system, "TWILIO_ACCOUNT_SID"},
  auth_token: {:system, "TWILIO_AUTH_TOKEN"},
  workspace_sid: {:system, "TWILIO_WORKSPACE_SID"},
  proxy_service_sid: {:system, "TWILIO_PROXY_SERVICE_SID"}
