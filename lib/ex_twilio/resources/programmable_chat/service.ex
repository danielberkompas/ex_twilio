defmodule ExTwilio.ProgrammableChat.Service do
  @moduledoc """
  Represents a Service resource in the Twilio Programmable Chat API.

  - [Twilio docs](https://www.twilio.com/docs/api/chat/rest/services)
  """
  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            date_created: nil,
            date_updated: nil,
            default_service_role_sid: nil,
            default_channel_role_sid: nil,
            default_channel_creator_role_sid: nil,
            typing_indicator_timeout: nil,
            read_status_enabled: nil,
            consumption_report_interval: nil,
            reachability_enabled: nil,
            limits: nil,
            pre_webhook_url: nil,
            post_webhook_url: nil,
            webhook_method: nil,
            webhook_filters: nil,
            notifications: nil,
            url: nil,
            links: nil

  use ExTwilio.Resource,
    import: [
      :stream,
      :all,
      :find,
      :create,
      :update,
      :destroy
    ]
end
