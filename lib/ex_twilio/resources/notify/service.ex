defmodule ExTwilio.Notify.Service do
  @moduledoc """
  Represents a Service resource in the Twilio Notify.

  - [Twilio docs](https://www.twilio.com/docs/notify/api/services)

  - friendly_name Human-readable name for this service instance
  - apn_credential_sid The SID of the `ExTwilio.Notify.Credential` to be used
  for APN Bindings.
  - gcm_credential_sid The SID of the `ExTwilio.Notify.Credential` to be used for GCM Bindings.
  - messaging_service_sid The SID of the [Messaging Service]
  (https://www.twilio.com/docs/api/rest/sending-messages#messaging-services) to
  be used for SMS Bindings. In order to send SMS notifications this parameter
  has to be set.
  - facebook_messenger_page_id The Page ID to be used to send for Facebook
  Messenger Bindings. It has to match the Page ID you configured when you
  [enabled Facebook Messaging](https://www.twilio.com/console/sms/settings) on your account.
  - default_apn_notification_protocol_version The version of the protocol to be
  used for sending APNS notifications. Can be overridden on a Binding by Binding basis when creating a `ExTwilio.Notify.Bindings` resource.
  - default_gcm_notification_protocol_version The version of the protocol to be
  used for sending GCM notifications. Can be overridden on a Binding by Binding
  basis when creating a `ExTwilio.Notify.Bindings` resource.
  - fcm_credential_sid The SID of the `ExTwilio.Notify.Credential` to be used
  for FCM Bindings.
  - default_fcm_notification_protocol_version The version of the protocol to be
  used for sending FCM notifications. Can be overridden on a Binding by Binding
  basis when creating a `ExTwilio.Notify.Credential` resource.
  - log_enabled The log_enabled
  - alexa_skill_id The alexa_skill_id
  - default_alexa_notification_protocol_version The default_alexa_notification_protocol_version

  """
  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            date_created: nil,
            date_updated: nil,
            apn_credential_sid: nil,
            gcm_credential_sid: nil,
            fcm_credential_sid: nil,
            messaging_service_sid: nil,
            facebook_messenger_page_id: nil,
            default_apn_notification_protocol_version: nil,
            default_gcm_notification_protocol_version: nil,
            default_fcm_notification_protocol_version: nil,
            log_enabled: nil,
            url: nil,
            links: nil,
            alexa_skill_id: nil,
            default_alexa_notification_protocol_version: nil

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
