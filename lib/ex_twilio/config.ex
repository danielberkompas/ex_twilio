defmodule ExTwilio.Config do
  @moduledoc """
  Stores configuration variables used to communicate with Twilio's API.

  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime.
  """

  @doc """
  Returns the Twilio Account SID. Set it in `mix.exs`:

      config :ex_twilio, account_sid: "YOUR_ACCOUNT_SID"
  """
  def account_sid, do: from_env(:ex_twilio, :account_sid)

  @doc """
  Returns the Twilio Auth Token for your account. Set it in `mix.exs`:

      config :ex_twilio, auth_token: "YOUR_AUTH_TOKEN"
  """
  def auth_token, do: from_env(:ex_twilio, :auth_token)

  @doc """
  Returns the domain of the Twilio API. This will default to "api.twilio.com",
  but can be overridden using the following setting in `mix.exs`:

      config :ex_twilio, api_domain: "other.twilio.com"
  """
  def api_domain, do: from_env(:ex_twilio, :api_domain, "api.twilio.com")

  @doc """
  Returns the protocol used for the Twilio API. The default is `"https"` for
  interacting with the Twilio API, but when testing with Bypass, you may want
  this to be `"http"`.
  """
  def protocol, do: Application.get_env(:ex_twilio, :protocol) || "https"

  @doc """
  Options added to HTTPoison requests
  """
  def request_options, do: from_env(:ex_twilio, :request_options, [])

  @doc """
  Returns the version of the API that ExTwilio is going to talk to. Set it in
  `mix.exs`:
      config :ex_twilio, api_version: "2015-05-06"
  """
  def api_version, do: Application.get_env(:ex_twilio, :api_version) || "2010-04-01"

  def workspace_sid, do: Application.get_env(:ex_twilio, :workspace_sid) || "12345"

  @doc """
  Return the combined base URL of the Twilio API, using the configuration
  settings given.
  """
  def base_url, do: "#{protocol()}://#{api_domain()}/#{api_version()}"

  def fax_url, do: "https://fax.twilio.com/v1"

  def task_router_url, do: "https://taskrouter.twilio.com/v1"

  def task_router_websocket_base_url, do: "https://event-bridge.twilio.com/v1/wschannels"

  def programmable_chat_url, do: "https://chat.twilio.com/v2"

  def notify_url, do: "https://notify.twilio.com/v1"

  def studio_url, do: "https://studio.twilio.com/v1"

  def video_url, do: "https://video.twilio.com/v1"

  def verify_url, do: "https://verify.twilio.com/v2"

  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples.
  """
  def from_env(otp_app, key, default \\ nil)

  def from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
