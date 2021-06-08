defmodule ExTwilio.JWT.AccessToken.ChatGrant do
  @moduledoc """
  A JWT grant to access a given Twilio chat service.

  ## Examples

      ExTwilio.JWT.AccessToken.ChatGrant.new(
        service_sid: "sid",
        endpoint_id: "123",
        deployment_role_sid: "sid",
        push_credential_sid: "sid"
      )

  """

  @enforce_keys [:service_sid]

  defstruct service_sid: nil, endpoint_id: nil, deployment_role_sid: nil, push_credential_sid: nil

  @type t :: %__MODULE__{
          service_sid: String.t(),
          endpoint_id: String.t(),
          deployment_role_sid: String.t(),
          push_credential_sid: String.t()
        }

  @doc """
  Create a new grant.
  """
  @spec new(attrs :: Keyword.t()) :: t
  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  defimpl ExTwilio.JWT.Grant do
    alias ExTwilio.Ext

    def type(_grant), do: "chat"

    def attrs(grant) do
      %{"service_sid" => grant.service_sid}
      |> Ext.Map.put_if("endpoint_id", grant.endpoint_id)
      |> Ext.Map.put_if("deployment_role_sid", grant.deployment_role_sid)
      |> Ext.Map.put_if("push_credential_sid", grant.push_credential_sid)
    end
  end
end
