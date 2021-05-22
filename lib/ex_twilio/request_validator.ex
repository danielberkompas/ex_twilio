defmodule ExTwilio.RequestValidator do
  @moduledoc """
  Validates the authenticity of a Twilio request.

  - [Twilio docs](https://www.twilio.com/docs/usage/security)
  """

  alias ExTwilio.Config

  use Bitwise

  def valid?(url, params, signature) do
    valid?(url, params, signature, Config.auth_token())
  end

  def valid?(url, params, signature, auth_token) do
    url
    |> data_for(params)
    |> compute_hmac(auth_token)
    |> Base.encode64()
    |> String.trim()
    |> secure_compare(signature)
  end

  defp data_for(url, params), do: url <> combine(params)

  defp combine(params) do
    params
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn key -> key <> Map.get(params, key) end)
    |> Enum.join()
  end

  defp compute_hmac(data, key), do: hmac(:sha, key, data)

  # TODO: remove when we require OTP 22
  if System.otp_release() >= "22" do
    defp hmac(digest, key, data), do: :crypto.mac(:hmac, digest, key, data)
  else
    defp hmac(digest, key, data), do: :crypto.hmac(digest, key, data)
  end

  # Implementation taken from Plug.Crypto
  # https://github.com/elixir-plug/plug/blob/master/lib/plug/crypto.ex
  #
  # Compares the two binaries in constant-time to avoid timing attacks.
  # See: http://codahale.com/a-lesson-in-timing-attacks/
  defp secure_compare(left, right) do
    if byte_size(left) == byte_size(right) do
      secure_compare(left, right, 0) == 0
    else
      false
    end
  end

  defp secure_compare(<<x, left::binary>>, <<y, right::binary>>, acc) do
    xorred = bxor(x, y)
    secure_compare(left, right, acc ||| xorred)
  end

  defp secure_compare(<<>>, <<>>, acc) do
    acc
  end
end
