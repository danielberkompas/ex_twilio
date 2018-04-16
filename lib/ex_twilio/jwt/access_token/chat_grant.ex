defmodule ExTwilio.JWT.AccessToken.ChatGrant do
  @enforce_keys [:service_sid]
  defstruct service_sid: nil, endpoint_id: nil, deployment_role_sid: nil, push_credential_sid: nil

  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  defimpl ExTwilio.JWT.Grant do
    alias ExTwilio.Ext

    def type(_grant), do: "chat"

    def attrs(grant) do
      %{"service_sid" => grant.service_sid, "endpoint_id" => grant.endpoint_id}
      |> Ext.Map.put_if("deployment_role_sid", grant.deployment_role_sid)
      |> Ext.Map.put_if("push_credential_sid", grant.push_credential_sid)
    end
  end
end
