defmodule ExTwilio.Fax do
  @moduledoc """
  Warning! currently in Public beta.

  Represents a Fax resource in the Twilio API.

  - [Twilio docs](https://www.twilio.com/docs/fax/api)

  Here is an example of sending an SMS message:

      ExTwilio.Fax.create(
        to: "+15558675310",
        from: "+15017122661",
        media_url: "https://www.twilio.com/docs/documents/25/justthefaxmaam.pdf"
      )

  """

  defstruct sid: nil,
            date_created: nil,
            date_updated: nil,
            account_sid: nil,
            from: nil,
            to: nil,
            num_pages: nil,
            status: nil,
            error_code: nil,
            error_message: nil,
            direction: nil,
            price: nil,
            price_unit: nil,
            api_version: nil,
            url: nil,
            links: nil,
            media_url: nil,
            media_sid: nil,
            quality: nil,
            duration: nil

  use ExTwilio.Resource, import: [:stream, :find, :create]
end
