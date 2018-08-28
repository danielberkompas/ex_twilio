defmodule ExTwilio.Notify.Notification do
  @moduledoc """
  Represents a Notification resource in the Twilio Notify.

  - [Twilio docs](https://www.twilio.com/docs/notify/api/notifications)

  - body (optional for all except Alexa) Indicates the notification body text.
  Translates to `data.twi_body` for FCM and GCM, `aps.alert.body` for  APNS,
  `Body` for SMS and Facebook Messenger and `request.message.data` for Alexa.
  For SMS either this, `body`, or the `media_url` attribute of the `Sms`
  parameter is required.  For Facebook Messenger either this parameter or the
  body attribute in the `FacebookMessenger` parameter is required.
  - priority Two priorities defined: `low` and `high` (default). `low`
  optimizes the client app's battery consumption, and notifications may be
  delivered with unspecified delay. This is the same as Normal priority for FCM
  and GCM or priority 5 for APNS. `high` sends the notification immediately,
  and can wake up a sleeping device. This is the same as High priority for FCM
  and GCM or priority 10 for APNS.  This feature is not supported by SMS and
  Facebook Messenger and will be ignored for deliveries via those channels.
  - ttl This parameter specifies how long (in seconds) the notification is
  valid. Delivery should be attempted if the device is offline. The maximum
  time to live supported is 4 weeks. The value zero means that the notification
  delivery is attempted immediately once but not stored for future delivery.
  The default value is 4 weeks.  This feature is not supported by SMS and
  Facebook Messenger and will be ignored for deliveries via those channels.
  - title (optional for all except Alexa) Indicates the notification title.
  This field is not visible on iOS phones and tablets but it is on Apple Watch
  and Android devices. Translates to `data.twi_title` for FCM and GCM,
  `aps.alert.title` for APNS and `displayInfo.content[0].title`,
  `displayInfo.content[].toast.primaryText` of `request.message` for Alexa. It
  is  not supported for SMS and Facebook Messenger and will be omitted from
  deliveries via those channels.
  - sound Indicates a sound to be played. Translates to `data.twi_sound` for
  FCM and GCM and `aps.sound` for APNS.  This parameter is not supported by SMS
  and Facebook Messenger and is omitted from deliveries via those channels.
  - action Specifies the actions to be displayed for the notification.
  Translates to `data.twi_action` for GCM and `aps.category` for APNS. This
  parameter is not supported by SMS and Facebook Messenger and is omitted from
  deliveries via those channels.
  - data This parameter specifies the custom key-value pairs of the
  notification's payload. Translates to `data` dictionary in FCM and GCM
  payload. FCM and GCM [reserves certain keys](https://firebase.google.com/docs/cloud-messaging/http-server-ref)
  that cannot be used for those channels. For APNS, attributes of `Data` will be
  inserted into the APNS payload as custom properties outside of the `aps`
  dictionary. For Alexa they are added to `request.message.data`. For all
  channels, the `twi_` prefix is reserved for Twilio for future use. Requests
  including custom data with keys starting with `twi_` will be rejected as 400
  Bad request and no delivery will be attempted.  This parameter is not
  supported by SMS and Facebook Messenger and is omitted from deliveries via
  those channels.
  -apn APNS specific payload that overrides corresponding attributes in a
  generic payload for Bindings with the apn BindingType. This value is mapped
  to the Payload item, therefore the `aps` key has to be used to change standard
  attributes. Adds custom key-value pairs to the root of the dictionary. Refer
  to  [APNS documentation](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html) for more
  details. The `twi_` key prefix for custom key-value pairs is reserved for
  Twilio for future use. Custom data with keys starting with `twi_` is not
  allowed.
  - gcm GCM specific payload that overrides corresponding attributes in generic
  payload for Bindings with gcm BindingType.  This value is mapped to the root
  json dictionary. Refer to [GCM documentation](https://developers.google.com/cloud-messaging/http-server-ref)
  for more details.  Target parameters `to`, `registration_ids`, and
  `notification_key` are not allowed. The `twi_` key prefix for custom key-value
  pairs is reserved for Twilio for future use. Custom data with keys starting
  with `twi_` is not allowed. FCM and GCM
  [reserves certain keys](https://firebase.google.com/docs/cloud-messaging/http-server-ref)
   that cannot be used for those channels.
  - sms SMS specific payload that overrides corresponding attributes in generic
  payload for Bindings with sms BindingType.  Each attribute in this JSON
  object is mapped to the corresponding form parameter of the Twilio
   [Message](https://www.twilio.com/docs/api/rest/sending-messages) resource.
   The following parameters of the Message resource are supported in snake case
   format: `body`, `media_urls`, `status_callback`, and `max_price`.  The
   `status_callback`  parameter overrides the corresponding parameter in the
   messaging service if  configured. The `media_urls` expects a JSON array.
   - facebook_messenger Messenger specific payload that overrides corresponding
   attributes in generic payload for Bindings with facebook-messenger
   BindingType.  This value is mapped to the root json dictionary of Facebook's
   [Send API  request](https://developers.facebook.com/docs/messenger-platform/send-api-reference).
    Overriding the `recipient` parameter is not allowed.
  - fcm FCM specific payload that overrides corresponding attributes in generic
  payload for Bindings with fcm BindingType.  This value is mapped to the root
  json dictionary. Refer to [FCM documentation](https://firebase.google.com/docs/cloud-messaging/http-server-ref#downstream)
  for more details.  Target parameters `to`, `registration_ids`, `condition`,
  and `notification_key` are not allowed. The `twi_` key prefix for custom
  key-value pairs is reserved for Twilio for future use. Custom data with keys
  starting with `twi_` is not allowed. Custom data with keys starting with
  `twi_` is not allowed. FCM and GCM
  [reserves certain keys](https://firebase.google.com/docs/cloud-messaging/http-server-ref)
  that cannot be used for those channels.
  - segment The segment
  - alexa The alexa
  - to_binding The destination address in a JSON object (see attributes below).
  Multiple ToBinding parameters can be included but the total size of the
  request entity should not exceed 1MB. This is typically sufficient for
  10,000 phone numbers.
  - identity Delivery will be attempted only to Bindings with an Identity in
  this list. Maximum 20 items allowed in this list.
  - tag Delivery will be attempted only to Bindings that have all of the Tags
  in this list. Maximum 5 items allowed in this list. The implicit tag "all" is
  available to notify all Bindings in a Service instance. Similarly the
  implicit tags "apn", "fcm", "gcm", "sms" and "facebook-messenger" are
  available to notify all Bindings of the given type.
  """
  defstruct sid: nil,
            account_sid: nil,
            service_sid: nil,
            date_created: nil,
            identities: nil,
            tags: nil,
            tag: nil,
            segments: nil,
            priority: nil,
            ttl: nil,
            title: nil,
            body: nil,
            sound: nil,
            action: nil,
            data: nil,
            apn: nil,
            gcm: nil,
            fcm: nil,
            sms: nil,
            facebook_messenger: nil,
            alexa: nil,
            to_binding: nil,
            identity: nil

  use ExTwilio.Resource,
    import: [
      :create
    ]
end
