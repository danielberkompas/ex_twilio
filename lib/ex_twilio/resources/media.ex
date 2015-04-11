defmodule ExTwilio.Media do
  @moduledoc """
  Represents an Media resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/media)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :destroy]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            parent_sid: nil,
            content_type: nil,
            uri: nil

  def resource_name, do: "Media"
  def resource_collection_name, do: "media_list"
  def parents, do: [:account, :message]
end
