defmodule ExTwilio.ConfigTest do
  use ExUnit.Case

  alias ExTwilio.Config

  describe "new/0" do
    test "should build a config with the default config" do
      config = Config.new()

      assert config.account
      assert config.workspace
      assert config.token
      assert config.api_version == "2010-04-01"
      assert config.urls.api == "https://api.twilio.com"
      assert config.urls.fax == "https://fax.twilio.com/v1"
      assert config.urls.task_router == "https://taskrouter.twilio.com/v1"
      assert config.urls.task_router_websocket == "https://event-bridge.twilio.com/v1/wschannels"
      assert config.urls.programmable_chat == "https://chat.twilio.com/v2"
      assert config.urls.notify == "https://notify.twilio.com/v1"
      assert config.urls.studio == "https://studio.twilio.com/v1"
      assert config.urls.video == "https://video.twilio.com/v1"
    end
  end

  describe "new/1" do
    test "should set a different account" do
      config = Config.new(account: "another_account")
      assert config.account == "another_account"
    end

    test "should set a different workspace" do
      config = Config.new(workspace: "another_workspace")
      assert config.workspace == "another_workspace"
    end

    test "should set a different token" do
      config = Config.new(token: "another_token")
      assert config.token == "another_token"
    end

    test "should set a different api_version" do
      config = Config.new(api_version: "another_version")
      assert config.api_version == "another_version"
    end

    test "should set the same domain to all urls" do
      config = Config.new(urls: [domain: "another.domain"])

      assert config.urls.api == "https://api.another.domain/"
      assert config.urls.fax == "https://fax.another.domain/v1"
      assert config.urls.task_router == "https://taskrouter.another.domain/v1"

      assert config.urls.task_router_websocket ==
               "https://event-bridge.another.domain/v1/wschannels"

      assert config.urls.programmable_chat == "https://chat.another.domain/v2"
      assert config.urls.notify == "https://notify.another.domain/v1"
      assert config.urls.studio == "https://studio.another.domain/v1"
      assert config.urls.video == "https://video.another.domain/v1"
    end

    test "should set a different domain for specific configs" do
      config = Config.new(urls: [fax: "fax.url", api: "api.url"])

      assert config.urls.api == "api.url"
      assert config.urls.fax == "fax.url"
      assert config.urls.task_router == "https://taskrouter.twilio.com/v1"
    end
  end
end
