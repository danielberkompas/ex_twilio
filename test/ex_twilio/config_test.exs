defmodule ExTwilio.ConfigTest do
  use ExUnit.Case

  alias ExTwilio.Config

  describe "account_sid/0" do
    test "required config" do
      value = System.get_env("TWILIO_TEST_ACCOUNT_SID")
      assert Config.account_sid() == value
    end
  end

  describe "auth_token/0" do
    test "required config" do
      value = System.get_env("TWILIO_TEST_AUTH_TOKEN")
      assert Config.auth_token() == value
    end
  end

  describe "workspace_id/0" do
    test "provided config" do
      value = System.get_env("TWILIO_TEST_WORKSPACE_SID")
      assert Config.workspace_sid() == value
    end

    test "default config" do
      clean_env(:workspace_sid)
      assert Config.workspace_sid() == "12345"
      put_env(:workspace_sid, {:system, "TWILIO_TEST_WORKSPACE_SID"})
    end
  end

  describe "api_domain/0" do
    test "default config" do
      assert Config.api_domain() == "api.twilio.com"
    end

    test "provided config" do
      put_env(:api_domain, "some.other.domain")
      assert Config.api_domain() == "some.other.domain"
      clean_env(:api_domain)
    end
  end

  describe "protocol/0" do
    test "default config" do
      assert Config.protocol() == "https"
    end

    test "provided config" do
      put_env(:protocol, "fakeprotocol")
      assert Config.protocol() == "fakeprotocol"
      clean_env(:protocol)
    end
  end

  describe "base_url/0" do
    test "default config" do
      assert Config.base_url() == "https://api.twilio.com/2010-04-01"
    end
  end

  describe "fax_url/0" do
    test "default config" do
      assert Config.fax_url() == "https://fax.twilio.com/v1"
    end

    test "provided config" do
      put_env(:fax_url, "another.fax.url")
      assert Config.fax_url() == "another.fax.url"
      clean_env(:fax_url)
    end
  end

  describe "task_router_url/0" do
    test "default config" do
      assert Config.task_router_url() == "https://taskrouter.twilio.com/v1"
    end

    test "provided config" do
      put_env(:task_router_url, "another.task.router.url")
      assert Config.task_router_url() == "another.task.router.url"
      clean_env(:task_router_url)
    end
  end

  describe "task_router_websocket_base_url/0" do
    test "default config" do
      assert Config.task_router_websocket_base_url() ==
               "https://event-bridge.twilio.com/v1/wschannels"
    end

    test "provided config" do
      put_env(:task_router_websocket_base_url, "another.task.router.websocket.url")
      assert Config.task_router_websocket_base_url() == "another.task.router.websocket.url"
      clean_env(:task_router_websocket_base_url)
    end
  end

  describe "programmable_chat_url/0" do
    test "default config" do
      assert Config.programmable_chat_url() == "https://chat.twilio.com/v2"
    end

    test "provided config" do
      put_env(:programmable_chat_url, "another.chat.url")
      assert Config.programmable_chat_url() == "another.chat.url"
      clean_env(:programmable_chat_url)
    end
  end

  describe "notify_url/0" do
    test "default config" do
      assert Config.notify_url() == "https://notify.twilio.com/v1"
    end

    test "provided config" do
      put_env(:notify_url, "another.notify.url")
      assert Config.notify_url() == "another.notify.url"
      clean_env(:notify_url)
    end
  end

  describe "sutdio_url/0" do
    test "default config" do
      assert Config.studio_url() == "https://studio.twilio.com/v1"
    end

    test "provided config" do
      put_env(:studio_url, "another.studio.url")
      assert Config.studio_url() == "another.studio.url"
      clean_env(:studio_url)
    end
  end

  describe "video_url/0" do
    test "default config" do
      assert Config.video_url() == "https://video.twilio.com/v1"
    end

    test "provided config" do
      put_env(:video_url, "another.video.url")
      assert Config.video_url() == "another.video.url"
      clean_env(:video_url)
    end
  end

  defp put_env(key, value) do
    Application.put_env(:ex_twilio, key, value)
  end

  defp clean_env(key) do
    Application.delete_env(:ex_twilio, key)
  end
end
