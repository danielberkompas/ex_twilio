defmodule ExTwilio.Lookup do
  @moduledoc """
    Represents the Lookup Api provided by Twilio

    - [Twilio docs](https://www.twilio.com/docs/api/lookups)
  """
  alias ExTwilio.{Parser, Config}
  alias ExTwilio.UrlGenerator, as: Url

  @base_url "https://lookups.twilio.com/v1/PhoneNumbers/"

  defmodule PhoneNumber do
    @moduledoc false
    defstruct url: nil,
              carrier: nil,
              caller_name: nil,
              national_format: nil,
              phone_number: nil,
              country_code: nil,
              add_ons: nil
  end

  @doc """
    Retrieves information based on the inputed phone number. Supports Twilio's add-ons.

    Examples -
    {:ok, info} = ExTwilio.Lookup.retrieve("12345678910", [Type: carrier])
  """
  def retrieve(phone_number, query \\ []) do
    auth = [basic_auth: {Config.account_sid(), Config.auth_token()}]
    query_string = "?" <> Url.to_query_string(query)

    "#{@base_url}#{phone_number}#{query_string}"
    |> HTTPoison.get!([], hackney: auth)
    |> Parser.parse(PhoneNumber)
  end
end
