defmodule ExTwilio.Media do
  @moduledoc """
  Represents an Media resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/media)

  ## Examples

  Since Media belong to a Message in Twilio's API, you must pass a Message SID
  to each function in this module.

      ExTwilio.Media.all(message: "message_sid")
  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            parent_sid: nil,
            content_type: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :destroy]

  def resource_name, do: "Media"
  def resource_collection_name, do: "media_list"
  def parents, do: [:account, :message]
end
