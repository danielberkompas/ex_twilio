defmodule ExTwilio.ConnectApp do
  @moduledoc """
  Represents an ConnectApp resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/connect-apps)
  """

  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update]

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            permissions: nil,
            friendly_name: nil,
            description: nil,
            company_name: nil,
            homepage_url: nil,
            authorize_redirect_url: nil,
            deauthorize_callback_url: nil,
            deauthorize_callback_method: nil,
            uri: nil

  def parents, do: [:account]
end
