defmodule ExTwilio.Verify.Service do
  @moduledoc """
  Represents a Service resource in the Twilio Verify API.
  - [Twilio docs](https://www.twilio.com/docs/verify/api/service)
  ## Examples
  Create a new Verify Service
      ExTwilio.Verify.Service.create(friendly_name: "My Verification Service")
  """
  defstruct sid: nil,
            account_sid: nil,
            friendly_name: nil,
            code_length: nil,
            lookup_enabled: nil,
            psd2_enabled: nil,
            skip_sms_to_landlines: nil,
            dtmf_input_required: nil,
            tts_name: nil,
            do_not_share_warning_enabled: nil,
            custom_code_enabled: nil,
            push: nil,
            totp: nil,
            default_template_sid: nil,
            date_created: nil,
            date_updated: nil,
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
