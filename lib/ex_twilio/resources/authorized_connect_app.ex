defmodule ExTwilio.AuthorizedConnectApp do
  @moduledoc """
  Represents an AuthorizedConnectApp resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/authorized-connect-apps)
  """

  defstruct date_created: nil,
            date_updated: nil,
            account_sid: nil,
            permissions: nil,
            connect_app_sid: nil,
            connect_app_friendly_name: nil,
            connect_app_description: nil,
            connect_app_company_name: nil,
            connect_app_homepage_url: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find]

  def parents, do: [:account]
end
