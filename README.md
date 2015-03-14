ExTwilio
========

## Installation

ExTwilio is available from Mix as a hex package, or directly through Github.

```elixir
def deps do
  [{:ex_twilio, "~> 1.0.0"}] # Or [{:ex_twilio, github: "danielberkompas/ex_twilio"}]
end
```

To use ExTwilio in your application, you'll need to update your `mix.exs` file
with the following variables:

```elixir
config :ex_twilio, account_sid: "TWILIO API TOKEN"
config :ex_twilio, auth_token: "TWILIO API SECRET'"
```
