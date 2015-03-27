defmodule ExTwilio.Media do
  def resource_name, do: "Media"
  def resource_collection_name, do: "media_list"

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :destroy]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            parent_sid: nil,
            content_type: nil,
            uri: nil
end
