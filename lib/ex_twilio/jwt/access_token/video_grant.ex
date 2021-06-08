defmodule ExTwilio.JWT.AccessToken.VideoGrant do
  @moduledoc """
  A JWT grant to access a given Twilio video service.

  ## Examples

      ExTwilio.JWT.AccessToken.VideoGrant.new(room: "room_id")

  """

  @enforce_keys [:room]

  defstruct room: nil

  @type t :: %__MODULE__{
          room: String.t()
        }

  @doc """
  Create a new grant.
  """
  @spec new(attrs :: Keyword.t()) :: t
  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  defimpl ExTwilio.JWT.Grant do
    def type(_grant), do: "video"

    def attrs(grant) do
      %{"room" => grant.room}
    end
  end
end
