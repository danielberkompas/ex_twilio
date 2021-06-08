defmodule ExTwilio.JWT.AccessToken do
  @moduledoc """
  A Twilio JWT access token, as described in the Twilio docs.

  https://www.twilio.com/docs/iam/access-tokens
  """

  alias ExTwilio.JWT.Grant
  alias ExTwilio.Ext
  use Joken.Config

  @enforce_keys [:account_sid, :api_key, :api_secret, :identity, :grants, :expires_in]

  defstruct token_identifier: nil,
            account_sid: nil,
            api_key: nil,
            api_secret: nil,
            identity: nil,
            grants: [],
            expires_in: nil

  @type t :: %__MODULE__{
          account_sid: String.t(),
          api_key: String.t(),
          api_secret: String.t(),
          identity: String.t(),
          grants: [ExTwilio.JWT.Grant.t()],
          expires_in: integer
        }

  @doc """
  Creates a new JWT access token.

  ## Examples

      AccessToken.new(
        account_sid: "account_sid",
        api_key: "api_key",
        api_secret: "secret",
        identity: "user@email.com",
        expires_in: 86_400,
        grants: [AccessToken.ChatGrant.new(service_sid: "sid")]
      )

  """
  @spec new(attrs :: Keyword.t()) :: t
  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Converts an access token into a string JWT.

  Will raise errors if the `token` does not have all the required fields.

  ## Examples

      token =
        AccessToken.new(
          account_sid: "account_sid",
          api_key: "api_key",
          api_secret: "secret",
          identity: "user@email.com",
          expires_in: 86_400,
          grants: [AccessToken.ChatGrant.new(service_sid: "sid")]
        )

      AccessToken.to_jwt!(token)
      # => "eyJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIiwidHlwIjoiSldUIn0.eyJleHAiOjE1MjM5MTIxODgsImdyYW50cyI6eyJjaGF0Ijp7ImVuZHBvaW50X2lkIjpudWxsLCJzZXJ2aWNlX3NpZCI6InNpZCJ9LCJpZGVudGl0eSI6InVzZXJAZW1haWwuY29tIn0sImlhdCI6MTUyMzkwNDk4OCwibmJmIjoxNTIzOTA0OTg3fQ.M_5dsj1VWBrIZKvcIdygSpmiMsrZdkplYYNjxEhBHk0"

  """
  @spec to_jwt!(t) :: String.t() | no_return
  def to_jwt!(token) do
    token =
      token
      |> Ext.Map.validate!(:account_sid, &is_binary/1, "must be a binary")
      |> Ext.Map.validate!(:api_key, &is_binary/1, "must be a binary")
      |> Ext.Map.validate!(:api_secret, &is_binary/1, "must be a binary")
      |> Ext.Map.validate!(:identity, &is_binary/1, "must be a binary")
      |> Ext.Map.validate!(:grants, &list_of_grants?/1, "must be a list of grants")
      |> Ext.Map.validate!(:expires_in, &is_integer/1, "must be an integer")

    token_config =
      %{}
      |> add_claim("grants", fn -> grants(token) end)
      |> add_claim("sub", fn -> token.account_sid end)
      |> add_claim("jti", fn -> token.token_identifier || "#{token.api_key}-#{random_str()}" end)
      |> add_claim("iss", fn -> token.api_key end)
      |> add_claim("nbf", fn -> DateTime.utc_now() |> DateTime.to_unix() end)
      |> add_claim("exp", fn -> (DateTime.utc_now() |> DateTime.to_unix()) + token.expires_in end)
      |> add_claim("iat", fn -> DateTime.utc_now() |> DateTime.to_unix() end)

    signer =
      Joken.Signer.create("HS256", token.api_secret, %{
        "typ" => "JWT",
        "alg" => "HS256",
        "cty" => "twilio-fpa;v=1"
      })

    Joken.generate_and_sign!(token_config, %{}, signer)
  end

  defp list_of_grants?(grants) when is_list(grants) do
    Enum.all?(grants, &Grant.impl_for(&1))
  end

  defp list_of_grants?(_other), do: false

  defp grants(token) do
    grants =
      Enum.reduce(token.grants, %{"identity" => token.identity}, fn grant, acc ->
        Map.put(acc, Grant.type(grant), Grant.attrs(grant))
      end)

    grants
  end

  defp random_str do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
    |> String.downcase()
  end
end
