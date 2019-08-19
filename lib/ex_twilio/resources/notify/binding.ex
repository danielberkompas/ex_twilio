defmodule ExTwilio.Notify.Binding do
  @moduledoc """
  Represents a Binding resource in the Twilio Notify.

  - [Twilio docs](https://www.twilio.com/docs/notify/api/bindings)

  - identity The Identity to which this Binding belongs to. Identity is defined
  by your application. Up to 20 Bindings can be created for the same Identity
  in a given Service.
  - binding_type The type of the Binding. This determines the transport technology to use. Allowed values: `apn`, `fcm`, `gcm`, `sms`, and `facebook-messenger`.
  - address The address specific to the channel. For APNS it is the device
  token. For FCM and GCM it is the registration token. For SMS it is a phone
  number in E.164 format. For Facebook Messenger it is the Messenger ID of the user or a phone number in E.164 format.
  - tag The list of tags associated with this Binding. Tags can be used to
  select the Bindings to use when sending a notification. Maximum 20 tags are
  allowed.
  - notification_protocol_version The version of the protocol (data format)
  used to send the notification. This defaults to the value of
  DefaultXXXNotificationProtocolVersion in the `ExTwilio.Notify.Service`.
  The current version is `"3"` for `apn`, `fcm`, and `gcm` type Bindings. The
  parameter is not applicable to `sms` and `facebook-messenger` type Bindings as the data format is fixed.
  - credential_sid The unique identifier (SID) of the
  `ExTwilio.Notify.Credential` resource to be used to send notifications to
  this Binding. If present, this overrides the Credential specified in the
  Service resource. Applicable only to `apn`, `fcm`, and `gcm` type Bindings.
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            credential_sid: nil,
            date_created: nil,
            date_updated: nil,
            notification_protocol_version: nil,
            identity: nil,
            binding_type: nil,
            address: nil,
            tags: nil,
            tag: nil,
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

  def parents,
    do: [
      %ExTwilio.Parent{module: ExTwilio.Notify.Service, key: :service}
    ]
end
