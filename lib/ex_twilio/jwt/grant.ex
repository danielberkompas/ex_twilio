defprotocol ExTwilio.JWT.Grant do
  @moduledoc """
  A protocol for converting grants into JWT claims.
  """

  @doc """
  The type of claim this grant is.

  ## Example

      def type(_grant), do: "chat"
  """
  def type(grant)

  @doc """
  The attributes of the claim.

  ## Example

      def attrs(grant) do
        %{"name" => grant.name}
      end
  """
  def attrs(grant)
end
