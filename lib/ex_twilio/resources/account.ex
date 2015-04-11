defmodule ExTwilio.Account do
  @moduledoc """
  Represents an Account or Subaccount resource.

  - [Account docs](https://www.twilio.com/docs/api/rest/accounts)
  - [Subaccount docs](https://www.twilio.com/docs/api/rest/subaccounts)
  """

  defstruct sid: nil,
            owner_account_sid: nil,
            date_created: nil,
            date_updated: nil,
            friendly_name: nil,
            type: nil,
            status: nil,
            auth_token: nil,
            uri: nil,
            subresource_uris: nil

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update]

  @doc """
  Suspend an Account by updating its status to "suspended".

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#suspending-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.suspend(account)
  """
  @spec suspend(map | String.t) :: Parser.success | Parser.error
  def suspend(%{sid: sid}), do: suspend(sid)
  def suspend(sid),         do: update(sid, status: "suspended")

  @doc """
  Reactivate a suspended Account by updating its status to "active".

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#suspending-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.reactivate(account)
  """
  def reactivate(%{sid: sid}), do: reactivate(sid)
  def reactivate(sid),         do: update(sid, status: "active")

  @doc """
  Permanently close an Account by updating its status to "closed". This cannot
  be undone, so use it carefully!

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#closing-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.close(account)
  """
  def close(%{sid: sid}), do: close(sid)
  def close(sid),         do: update(sid, status: "closed")

  def parents, do: [:account]
end
