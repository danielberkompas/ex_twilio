defmodule ExTwilio.Config do
  @account_sid Application.get_env(:ex_twilio, :account_sid)
  @auth_token  Application.get_env(:ex_twilio, :auth_token)
  @api_domain  Application.get_env(:ex_twilio, :base_url) || "api.twilio.com"
  @api_version Application.get_env(:ex_twilio, :api_version) || "2010-04-01"

  @moduledoc """
  Provides easy access into ExTwilio's configuration for all the modules that
  need to know.
  """

  @doc """
  Returns the Twilio Account SID. Set it in `mix.exs`:
  
      config :ex_twilio, account_sid: "YOUR_ACCOUNT_SID"
  """
  def account_sid, do: @account_sid

  @doc """
  Returns the Twilio Auth Token for your account. Set it in `mix.exs`:

      config :ex_twilio, auth_token: "YOUR_AUTH_TOKEN"
  """
  def auth_token,  do: @auth_token

  @doc """
  Returns the domain of the Twilio API. This will default to "api.twilio.com",
  but can be overridden using the following setting in `mix.exs`:

      config :ex_twilio, api_domain: "other.twilio.com"
  """
  def api_domain,  do: @api_domain

  @doc """
  Returns the version of the API that ExTwilio is going to talk to. Set it in
  `mix.exs`:

      config :ex_twilio, api_version: "2015-05-06"
  """
  def api_version, do: @api_version

  @doc """
  Return the combined base URL of the Twilio API, using the configuration 
  settings given.
  """
  def base_url do
    "https://#{api_domain}/#{api_version}/"
  end
end
