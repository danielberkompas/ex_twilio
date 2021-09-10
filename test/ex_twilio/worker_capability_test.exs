defmodule ExTwilio.WorkerCapabilityTest do
  use ExUnit.Case

  alias ExTwilio.Config
  alias ExTwilio.WorkerCapability

  test ".new sets the worker capability to one hour" do
    assert WorkerCapability.new("worker_sid", "workspace_sid").ttl == 3600
  end

  test ".new sets the start time for the TTL to be the current time" do
    assert_in_delta WorkerCapability.new("worker_sid", "workspace_sid").start_time,
                    :erlang.system_time(:seconds),
                    1000
  end

  test ".new sets the account sid from the config" do
    assert WorkerCapability.new("worker_sid", "workspace_sid").account_sid ==
             Config.new().account
  end

  test ".new sets the auth token from the config" do
    assert WorkerCapability.new("worker_sid", "workspace_sid").auth_token ==
             Config.new().token
  end

  test ".new sets the worker sid" do
    assert WorkerCapability.new("worker_sid", "workspace_sid").worker_sid == "worker_sid"
  end

  test ".new sets the workspace sid" do
    assert WorkerCapability.new("worker_sid", "workspace_sid").workspace_sid ==
             "workspace_sid"
  end

  test ".token sets the issuer to the account sid" do
    assert decoded_token(WorkerCapability.new("worker_sid", "workspace_sid")).claims[
             "iss"
           ] == Config.new().account
  end

  test ".token sets 9 policies" do
    jwt =
      WorkerCapability.new("worker_sid", "workspace_sid")
      |> WorkerCapability.allow_activity_updates()
      |> WorkerCapability.allow_reservation_updates()

    assert length(decoded_token(jwt).claims["policies"]) == 9
  end

  defp decoded_token(capability) do
    signer = Joken.Signer.create("HS256", Config.new().token)

    {:ok, verified} =
      capability
      |> WorkerCapability.token()
      |> Joken.verify(signer)

    %{claims: verified}
  end
end
