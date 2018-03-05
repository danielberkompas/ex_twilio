defmodule ExTwilio.WorkerCapability do
  @moduledoc """
  Capability tokens are used to sign communications from devices
  to Twilio. You create a token on your server, specify what
  capabilities you would like your device to have, then pass
  the token to your client to use. The tokens generated are
  JSON Web Tokens (JWT).

  - [Capability docs](https://www.twilio.com/docs/api/client/capability-tokens)
  - [JWT docs](https://jwt.io/introduction/)

  ## Example

      ExTwilio.WorkerCapability.new("worker_sid", "workspace_sid")
      |> ExTwilio.WorkerCapability.token
      "xxxxx.yyyyy.zzzzz"
  """

  alias ExTwilio.Config

  defstruct account_sid: nil,
            auth_token: nil,
            policies: [],
            start_time: nil,
            ttl: nil,
            worker_sid: nil,
            workspace_sid: nil

  @type t :: %__MODULE__{
          account_sid: String.t() | nil,
          auth_token: String.t() | nil,
          policies: list,
          start_time: non_neg_integer | nil,
          ttl: non_neg_integer | nil,
          worker_sid: String.t() | nil,
          workspace_sid: String.t() | nil
        }

  @doc """
  Initialises a new capability specification with a TTL of one hour,
  and the accound sid and auth token taken from the configuration.

  ## Example

      ExTwilio.WorkerCapability.new
  """
  @spec new(String.t(), String.t()) :: t
  def new(worker_sid, workspace_sid) do
    %__MODULE__{}
    |> starting_at(:erlang.system_time(:seconds))
    |> with_ttl(3600)
    |> with_account_sid(Config.account_sid())
    |> with_auth_token(Config.auth_token())
    |> with_worker_sid(worker_sid)
    |> with_workspace_sid(workspace_sid)
  end

  @doc """
  Sets the time at which the TTL begins in seconds since epoch.

  ## Example

  Sets the TTL to begin on 24th May, 2016

      ExTwilio.WorkerCapability.starting_at(1464096368)
  """
  @spec starting_at(t, non_neg_integer) :: t
  def starting_at(capability_struct = %__MODULE__{}, start_time) do
    %{capability_struct | start_time: start_time}
  end

  @doc """
  Sets the Twilio account sid used to issue the token.

  ## Example

  Sets the account sid to be XXX

      ExTwilio.WorkerCapability.with_account_sid('XXX')
  """
  @spec with_account_sid(t, String.t()) :: t
  def with_account_sid(capability_struct = %__MODULE__{}, account_sid) do
    %{capability_struct | account_sid: account_sid}
  end

  @doc """
  Sets the Twilio account auth token used to sign the capability token.

  ## Example

  Sets the auth token to be XXX

      ExTwilio.WorkerCapability.with_auth_token('XXX')
  """
  @spec with_auth_token(t, String.t()) :: t
  def with_auth_token(capability_struct = %__MODULE__{}, auth_token) do
    %{capability_struct | auth_token: auth_token}
  end

  @doc """
  Sets the Twilio worker sid used to sign the capability token.

  ## Example

  Sets the worker sid to be XXX

      ExTwilio.WorkerCapability.with_worker_sid('XXX')
  """
  @spec with_worker_sid(t, String.t()) :: t
  def with_worker_sid(capability_struct = %__MODULE__{}, worker_sid) do
    %{capability_struct | worker_sid: worker_sid}
  end

  @doc """
  Sets the Twilio workspace sid used to sign the capability token.

  ## Example

  Sets the workspace sid to be XXX

      ExTwilio.WorkerCapability.with_workspace_sid('XXX')
  """
  @spec with_workspace_sid(t, String.t()) :: t
  def with_workspace_sid(capability_struct = %__MODULE__{}, workspace_sid) do
    %{capability_struct | workspace_sid: workspace_sid}
  end

  @doc """
  Sets the TTL of the token in seconds.

  - [TTL docs](
  https://www.twilio.com/docs/api/client/capability-tokens#token-expiration)

  ## Example

  Sets the TTL to one hour

      ExTwilio.WorkerCapability.with_ttl(3600)
  """
  @spec with_ttl(t, non_neg_integer) :: t
  def with_ttl(capability_struct = %__MODULE__{}, ttl) do
    %{capability_struct | ttl: ttl}
  end

  def allow_activity_updates(
        capability_struct = %__MODULE__{
          policies: policies,
          worker_sid: worker_sid,
          workspace_sid: workspace_sid
        }
      ) do
    policy =
      add_policy(worker_reservation_url(workspace_sid, worker_sid), "POST", true, nil, %{
        "ActivitySid" => %{required: true}
      })

    Map.put(capability_struct, :policies, [policy | policies])
  end

  def allow_reservation_updates(
        capability_struct = %__MODULE__{
          policies: policies,
          worker_sid: worker_sid,
          workspace_sid: workspace_sid
        }
      ) do
    policies = allow(policies, task_url(workspace_sid), "POST")
    policy = add_policy(worker_reservation_url(workspace_sid, worker_sid), "POST")
    Map.put(capability_struct, :policies, [policy | policies])
  end

  @doc """
  Generates a JWT token based on the requested policies

  ## Example

  Generates and signs a token with the provided capabilities

      ExTwilio.WorkerCapability.token
  """
  @spec token(t) :: String.t()
  def token(%__MODULE__{
        account_sid: account_sid,
        auth_token: auth_token,
        policies: policies,
        start_time: start_time,
        ttl: ttl,
        worker_sid: worker_sid,
        workspace_sid: workspace_sid
      }) do
    policies
    |> allow(websocket_requests_url(worker_sid, account_sid), "GET")
    |> allow(websocket_requests_url(worker_sid, account_sid), "POST")
    |> allow(workspaces_base_url(workspace_sid), "GET")
    |> allow(activity_url(workspace_sid), "GET")
    |> allow(task_url(workspace_sid), "GET")
    |> allow(worker_reservation_url(workspace_sid, worker_sid), "GET")
    |> jwt_payload(account_sid, expiration_time(start_time, ttl), workspace_sid, worker_sid)
    |> generate_jwt(auth_token)
  end

  def allow(policies, url, method, query_filters \\ %{}, post_filters \\ %{}) do
    policy = add_policy(url, method, true, query_filters, post_filters)
    [policy | policies]
  end

  defp websocket_requests_url(worker_sid, account_sid) do
    "#{Config.task_router_websocket_base_url()}/#{account_sid}/#{worker_sid}"
  end

  defp expiration_time(start_time, ttl) do
    start_time + ttl
  end

  defp jwt_payload(policies, issuer, expiration_time, workspace_sid, worker_sid) do
    %{
      "iss" => issuer,
      "exp" => expiration_time,
      "workspace_sid" => workspace_sid,
      "friendly_name" => worker_sid,
      "account_sid" => issuer,
      "version" => "v1",
      "policies" => policies,
      "channel" => worker_sid,
      "worker_sid" => worker_sid
    }
  end

  defp add_policy(url, method) do
    add_policy(url, method, true, %{}, %{})
  end

  defp add_policy(url, method, allowed, query_filters, post_filters) do
    %{
      "url" => url,
      "post_filter" => post_filters,
      "method" => method,
      "allowed" => allowed,
      "query_filter" => query_filters
    }
  end

  defp generate_jwt(payload, secret) do
    payload
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.sign()
    |> Joken.get_compact()
  end

  defp workspaces_base_url(workspace_sid) do
    "#{Config.task_router_url()}/Workspaces/#{workspace_sid}"
  end

  defp task_url(workspace_sid) do
    "#{workspaces_base_url(workspace_sid)}/Tasks/**"
  end

  defp activity_url(workspace_sid) do
    "#{workspaces_base_url(workspace_sid)}/Activities"
  end

  defp worker_reservation_url(workspace_sid, worker_sid) do
    "#{workspaces_base_url(workspace_sid)}/Workers/#{worker_sid}"
  end
end
