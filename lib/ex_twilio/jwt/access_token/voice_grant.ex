defmodule ExTwilio.JWT.AccessToken.VoiceGrant do
  @moduledoc """
  A JWT grant to access a given Twilio voice service.

  ## Examples

      ExTwilio.JWT.AccessToken.VoiceGrant.new(
        outgoing_application_sid: "application_sid",
        outgoing_application: %{"key" => "value"},
        incoming_allow: true,
        push_credential_sid: "push_credential_sid",
        endpoint_id: "endpoint_id"
      )

  """

  defstruct outgoing_application_sid: nil,
            outgoing_application_params: nil,
            incoming_allow: nil,
            push_credential_sid: nil,
            endpoint_id: nil

  @type t :: %__MODULE__{
          outgoing_application_sid: String.t(),
          outgoing_application_params: String.t(),
          incoming_allow: boolean(),
          push_credential_sid: String.t(),
          endpoint_id: String.t()
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

    def type(_grant), do: "voice"

    def attrs(grant) do
      %{}
      |> Ext.Map.put_if("outgoing", outgoing_attrs(grant))
      |> Ext.Map.put_if("incoming", incoming_attrs(grant))
      |> Ext.Map.put_if("push_credential_sid", grant.push_credential_sid)
      |> Ext.Map.put_if("endpoint_id", grant.endpoint_id)
    end

    defp outgoing_attrs(%{outgoing_application_sid: sid} = grant)
         when is_binary(sid) and sid != "" do
      Ext.Map.put_if(%{"application_sid" => sid}, "params", grant.outgoing_application_params)
    end

    defp outgoing_attrs(_grant), do: nil

    defp incoming_attrs(%{incoming_allow: incoming_allow}) when is_boolean(incoming_allow) do
      %{"allow" => incoming_allow}
    end

    defp incoming_attrs(_grant), do: nil
  end
end
