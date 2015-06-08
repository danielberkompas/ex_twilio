defmodule ExTwilio.Notification do
  @moduledoc """
  Represents an Notification resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/api/rest/notifications)
  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            call_sid: nil,
            api_version: nil,
            log: nil,
            error_code: nil,
            more_info: nil,
            message_text: nil,
            message_date: nil,
            request_url: nil,
            request_method: nil,
            request_variables: nil,
            response_headers: nil,
            response_body: nil,
            uri: nil

  use ExTwilio.Resource, import: [:stream, :all, :find, :destroy]

  def parents, do: [:account, :call]
end
