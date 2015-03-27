defmodule ExTwilio.AuthorizedConnectApp do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find]

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
end
