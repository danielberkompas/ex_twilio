defmodule ExTwilio.Capability do
  @moduledoc """
  Capability tokens are used to sign communications from devices
  to Twilio. You create a token on your server, specify what
  capabilities you would like your device to have, then pass
  the token to your client to use. The tokens generated are
  JSON Web Tokens (JWT).

  - [Capability docs](https://www.twilio.com/docs/api/client/capability-tokens)
  - [JWT docs](https://jwt.io/introduction/)

  ## Example

      ExTwilio.Capability.new
      |> ExTwilio.Capability.allow_client_incoming("tommy")
      |> ExTwilio.Capability.allow_client_outgoing("APabe7650f654fc34655fc81ae71caa3ff")
      |> ExTwilio.Capability.token
      "xxxxx.yyyyy.zzzzz"
  """

  alias ExTwilio.Config

  defstruct incoming_client_names: [],
            outgoing_client_app: nil,
            ttl: nil,
            start_time: nil,
            auth_token: nil,
            account_sid: nil

  @type outgoing_client_app :: {String.t(), map}

  @type t :: %__MODULE__{
          incoming_client_names: list,
          outgoing_client_app: outgoing_client_app | nil,
          ttl: non_neg_integer | nil,
          start_time: non_neg_integer | nil,
          auth_token: String.t() | nil,
          account_sid: String.t() | nil
        }

  @doc """
  Initialises a new capability specification with a TTL of one hour,
  and the account sid and auth token taken from the configuration.

  ## Example

      ExTwilio.Capability.new
  """
  @spec new :: t
  def new do
    %__MODULE__{}
    |> starting_at(:erlang.system_time(:seconds))
    |> with_ttl(3600)
    |> with_account_sid(Config.account_sid())
    |> with_auth_token(Config.auth_token())
  end

  @doc """
  Gives the device a client name allowing incoming connections
  to the client identified by the provided `client_name`.

  - [Incoming capability docs](
  https://www.twilio.com/docs/api/client/capability-tokens#allow-incoming-connections)

  ## Example

  A device with this token will be identified as `tommy`

      ExTwilio.Capability.allow_client_incoming("tommy")
  """
  @spec allow_client_incoming(String.t()) :: t
  def allow_client_incoming(client_name), do: allow_client_incoming(new(), client_name)

  @spec allow_client_incoming(t, String.t()) :: t
  def allow_client_incoming(
        capability_struct = %__MODULE__{incoming_client_names: client_names},
        client_name
      ) do
    %{
      capability_struct
      | incoming_client_names: client_names ++ [client_name]
    }
  end

  @doc """
  Gives the device an application sid so that Twilio can
  determine the voice URL to use to handle any outgoing
  connection.

  - [Outgoing capability docs](
  https://www.twilio.com/docs/api/client/capability-tokens#allow-outgoing-connections)

  ## Example

  Outgoing connections will use the Twilio application with the
  SID: `APabe7650f654fc34655fc81ae71caa3ff`

      ExTwilio.Capability.allow_client_outgoing("APabe7650f654fc34655fc81ae71caa3ff")
  """
  @spec allow_client_outgoing(String.t()) :: t
  def allow_client_outgoing(app_sid), do: allow_client_outgoing(new(), app_sid)

  @spec allow_client_outgoing(String.t(), map) :: t
  def allow_client_outgoing(app_sid, app_params = %{}) when is_binary(app_sid) do
    allow_client_outgoing(new(), app_sid, app_params)
  end

  @spec allow_client_outgoing(t, String.t()) :: t
  def allow_client_outgoing(capability_struct = %__MODULE__{}, app_sid) when is_binary(app_sid) do
    allow_client_outgoing(capability_struct, app_sid, %{})
  end

  @spec allow_client_outgoing(t, String.t(), map) :: t
  def allow_client_outgoing(capability_struct = %__MODULE__{}, app_sid, app_params = %{}) do
    %{capability_struct | outgoing_client_app: {app_sid, app_params}}
  end

  @doc """
  Sets the time at which the TTL begins in seconds since epoch.

  ## Example

  Sets the TTL to begin on 24th May, 2016

      ExTwilio.Capability.starting_at(1464096368)
  """
  @spec starting_at(t, non_neg_integer) :: t
  def starting_at(capability_struct = %__MODULE__{}, start_time) do
    %{capability_struct | start_time: start_time}
  end

  @doc """
  Sets the Twilio account sid used to issue the token.

  ## Example

  Sets the account sid to be XXX

      ExTwilio.Capability.with_account_sid('XXX')
  """
  @spec with_account_sid(t, String.t()) :: t
  def with_account_sid(capability_struct = %__MODULE__{}, account_sid) do
    %{capability_struct | account_sid: account_sid}
  end

  @doc """
  Sets the Twilio account auth token used to sign the capability token.

  ## Example

  Sets the auth token to be XXX

      ExTwilio.Capability.with_auth_token('XXX')
  """
  @spec with_auth_token(t, String.t()) :: t
  def with_auth_token(capability_struct = %__MODULE__{}, auth_token) do
    %{capability_struct | auth_token: auth_token}
  end

  @doc """
  Sets the TTL of the token in seconds.

  - [TTL docs](
  https://www.twilio.com/docs/api/client/capability-tokens#token-expiration)

  ## Example

  Sets the TTL to one hour

      ExTwilio.Capability.with_ttl(3600)
  """
  @spec with_ttl(t, non_neg_integer) :: t
  def with_ttl(capability_struct = %__MODULE__{}, ttl) do
    %{capability_struct | ttl: ttl}
  end

  @doc """
  Generates a JWT token based on the requested capabilities
  that can be provided to the Twilio client. Supports clients
  with multiple capabilties.

  - [Multiple capability docs](
  https://www.twilio.com/docs/api/client/capability-tokens#multiple-capabilities)

  ## Example

  Generates and signs a token with the provided capabilities

      ExTwilio.Capability.token
  """
  @spec token(t) :: String.t()
  def token(
        capability_struct = %__MODULE__{
          account_sid: account_sid,
          start_time: start_time,
          ttl: ttl,
          auth_token: auth_token
        }
      ) do
    capability_struct
    |> capabilities
    |> as_jwt_scope
    |> jwt_payload(account_sid, expiration_time(start_time, ttl))
    |> generate_jwt(auth_token)
  end

  defp capabilities(capability_struct = %__MODULE__{}) do
    incoming_capabililities(capability_struct) ++ outgoing_capabilities(capability_struct)
  end

  defp outgoing_capabilities(%__MODULE__{outgoing_client_app: nil}) do
    []
  end

  defp outgoing_capabilities(%__MODULE__{outgoing_client_app: {app_sid, app_params}})
       when app_params == %{} do
    ["scope:client:outgoing?appSid=#{URI.encode(app_sid)}"]
  end

  defp outgoing_capabilities(%__MODULE__{outgoing_client_app: {app_sid, app_params}}) do
    app_sid = URI.encode(app_sid)

    app_params =
      app_params
      |> URI.encode_query()
      |> URI.encode(&(!URI.char_reserved?(&1)))

    ["scope:client:outgoing?appSid=#{app_sid}&appParams=#{app_params}"]
  end

  defp incoming_capabililities(%__MODULE__{incoming_client_names: client_names}) do
    Enum.map(client_names, &incoming_capability(&1))
  end

  defp incoming_capability(client_name) do
    "scope:client:incoming?clientName=#{URI.encode(client_name)}"
  end

  defp as_jwt_scope(capabilities) do
    Enum.join(capabilities, " ")
  end

  defp expiration_time(start_time, ttl) do
    start_time + ttl
  end

  defp jwt_payload(scope, issuer, expiration_time) do
    %{
      "scope" => scope,
      "iss" => issuer,
      "exp" => expiration_time
    }
  end

  defp generate_jwt(payload, secret) do
    payload
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.sign()
    |> Joken.get_compact()
  end
end
