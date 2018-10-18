defmodule ExTwilio.Notify.Credential do
  @moduledoc """
  Represents a Credential resource in the Twilio Notify.

  - [Twilio docs](https://www.twilio.com/docs/notify/api/credentials)

  - type Credential type, one of "gcm", "fcm", or "apn"
  - friendly_name Friendly name for stored credential
  - certificate [APN only] URL encoded representation of the certificate. Strip everything outside of the headers, e.g. `-----BEGIN
  CERTIFICATE-----MIIFnTCCBIWgAwIBAgIIAjy9H849+E8wDQYJKoZIhvcNAQEFBQAwgZYxCzAJBgNV.....A==-----END CERTIFICATE-----`
  - private_key [APN only] URL encoded representation of the private key. Strip everything outside of the headers, e.g. `-----BEGIN RSA PRIVATE
  KEY-----MIIEpQIBAAKCAQEAuyf/lNrH9ck8DmNyo3fGgvCI1l9s+cmBY3WIz+cUDqmxiieR\n.-----END RSA PRIVATE KEY-----`
  - sandbox [APN only] use this credential for sending to production or sandbox APNs (string `true` or `false`)
  - api_key [GCM only] This is the "Server key" of your project from
  Firebase console under Settings / Cloud messaging. Yes, you can use the
  server key from the Firebase console for GCM.
  - secret [FCM only] This is the "Server key" of your project from Firebase console under Settings / Cloud messaging.
  """
  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            type: nil,
            certificate: nil,
            private_key: nil,
            sandbox: nil,
            api_key: nil,
            secret: nil,
            date_created: nil,
            date_updated: nil,
            url: nil

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
