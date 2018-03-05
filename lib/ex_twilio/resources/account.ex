defmodule ExTwilio.Account do
  @moduledoc """
  Represents an Account or Subaccount resource.

  - [Account docs](https://www.twilio.com/docs/api/rest/accounts)
  - [Subaccount docs](https://www.twilio.com/docs/api/rest/subaccounts)

  ## Examples

  An ExTwilio.Account can represent either an Account or a SubAccount. To see
  all accounts and subaccounts that your auth_token has access to, run:

      ExTwilio.Account.all

  If you want to find a SubAccount, use `find/1`.

      ExTwilio.Account.find("sid")

  If you want to see items associated with a SubAccount, you can do so by
  passing in an `account:` option in all other ExTwilio resources. For example:

      ExTwilio.Call.list(account: "subaccount_sid")
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

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update]

  @doc """
  Suspend an Account by updating its status to "suspended".

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#suspending-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.suspend(account)
  """
  @spec suspend(map | String.t()) :: Parser.success() | Parser.error()
  def suspend(%{sid: sid}), do: suspend(sid)
  def suspend(sid), do: update(sid, status: "suspended")

  @doc """
  Reactivate a suspended Account by updating its status to "active".

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#suspending-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.reactivate(account)
  """
  @spec reactivate(map | String.t()) :: Parser.success() | Parser.error()
  def reactivate(%{sid: sid}), do: reactivate(sid)
  def reactivate(sid), do: update(sid, status: "active")

  @doc """
  Permanently close an Account by updating its status to "closed". This cannot
  be undone, so use it carefully!

  - [Twilio Docs](https://www.twilio.com/docs/api/rest/subaccounts#closing-subaccounts)

  ## Example

      {:ok, account} = ExTwilio.Account.find("<sid>")
      ExTwilio.Account.close(account)
  """
  @spec close(map | String.t()) :: Parser.success() | Parser.error()
  def close(%{sid: sid}), do: close(sid)
  def close(sid), do: update(sid, status: "closed")

  def parents, do: [:account]
end
