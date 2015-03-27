defmodule ExTwilio.Notification do
  use ExTwilio.Resource, import: [:stream, :all, :list, :find, :destroy]

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
end
