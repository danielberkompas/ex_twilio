defprotocol ExTwilio.JWT.Grant do
  @moduledoc """
  A protocol for converting grants into JWT claims.
  """

  @doc """
  The type of claim this grant is.

  ## Examples

      def type(_grant), do: "chat"

  """
  def type(grant)

  @doc """
  The attributes of the claim.

  ## Examples

      def attrs(grant) do
        %{"name" => grant.name}
      end

  """
  def attrs(grant)
end
