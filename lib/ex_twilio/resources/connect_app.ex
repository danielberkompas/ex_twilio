defmodule ExTwilio.ConnectApp do
  @moduledoc """
  Represents an ConnectApp resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/connect-apps)
  """

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

  use ExTwilio.Resource, import: [:stream, :all, :find, :create, :update]

  def parents, do: [:account]
end
