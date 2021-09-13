defmodule ExTwilio.Config do
  @moduledoc """
  Abstracts all configuration for interactions with Twilio API.
  This enables ExTwilio to work with multiple accounts, since the auth token, account sid,
  workspace sid and api version are all specified in the config struct.
  Now you can do requests with different auth token, account sid and manage multiple account
  interactions with Twilio.

  The config can be used to allow ExTwilio to be used in tests too.
  You're able to provide an specific url for any Twilio API subdomain.
  You're also able to provide a different domain to build the proper subdomains urls.

  The Confi
  """
  defstruct account: nil, api_version: nil, token: nil, workspace: nil, urls: %{}

  alias ExTwilio.Config.Env

  @typedoc """
  Config struct with all credentials and urls required to interact with Twilio.
  - urls: urls for the various Twilio services.
  - account: Account SID used for your interactions.
  - api_version: The API version set for interactions with `api.twilio.com`
  - token: The Auth Token to be used on requests.
  - workspace The Worspace SID used for interactions that requires a Workspace SID.
  """
  @type t :: %__MODULE__{
          urls: %{
            api: String.t() | nil,
            fax: String.t() | nil,
            task_router: String.t() | nil,
            task_router_websocket: String.t() | nil,
            programmable_chat: String.t() | nil,
            notify: String.t() | nil,
            studio: String.t() | nil,
            video: String.t() | nil
          },
          account: String.t() | nil,
          api_version: String.t() | nil,
          token: String.t() | nil,
          workspace: String.t() | nil
        }

  @typedoc """
  Options to configure identity and api version and urls for Twilio.
  - urls: optional configuration for Twilio urls.
  - account: Account SID to use when iteracting with Twilio API.
  - api_version: set the specific version of the API to interact, fallbacks to `2010-04-01`.
  - token: Twilio Auth Token for your account.
  - workspace: Workspace SID to use when interacting with Twilio API that requires Workspace SID.
  """
  @type config_opts :: [
          urls: url_opts(),
          account: String.t() | nil,
          api_version: String.t() | nil,
          token: String.t() | nil,
          workspace: String.t() | nil
        ]

  @typedoc """
  Options to configure the url used to do request for the specific Twilio subdomains.
  If no options are provided it gonna fallback for the default urls.
  - domain: for the use case of only changing the `twilio.com` domain for all subdomains.
  - api: set the specific url to be used for `api.twilio.com`.
  - fax: set the specific url to be used for `fax.twilio.com`.
  - task_router: set the specific url to be used for `taskrouter.twilio.com`.
  - task_router_websocket: set the specific url to be used for `event-bridge.twilio.com/v1/wschannels`.
  - programmable_chat: set the specific url to be used for `chat.twilio.com`.
  - notify: set the specific url to be used for `notify.twilio.com`.
  - studio: set the specific url to be used for `studio.twilio.com`.
  - video: set the specific url to be used for `video.twilio.com`.
  """
  @type url_opts :: [
          domain: String.t() | nil,
          api: String.t() | nil,
          fax: String.t() | nil,
          task_router: String.t() | nil,
          task_router_websocket: String.t() | nil,
          programmable_chat: String.t() | nil,
          notify: String.t() | nil,
          studio: String.t() | nil,
          video: String.t() | nil
        ]
  @doc """
  It generates a new config struct to be used with ExTwilio functions.
  Available options are `t:ExTwilio.Config.config_opts/0`.

  If no options are provided it gonna fallback to the Application config.
  Available Application env are:
  - account_sid
  - workspace_sid
  - auth_token
  - api_domain
  - protocol
  - request_options
  - api_version
  - fax_url
  - task_router_url
  - task_router_websocket_base_url
  - programmable_chat_url
  - notify_url
  - studio_url
  - video_url
  - domain
  """
  @spec new(config_opts()) :: t()
  def new(opts \\ []) do
    %__MODULE__{
      urls: build_urls(opts[:urls] || []),
      api_version: opts[:api_version] || Env.api_version(),
      account: opts[:account] || Env.account_sid(),
      token: opts[:token] || Env.auth_token(),
      workspace: opts[:workspace] || Env.workspace_sid()
    }
  end

  defp build_urls(opts) do
    %{
      api: api_url(opts),
      fax: fax_url(opts),
      task_router: task_router_url(opts),
      task_router_websocket: task_router_websocket_url(opts),
      programmable_chat: programmable_chat_url(opts),
      notify: notify_url(opts),
      studio: studio_url(opts),
      video: video_url(opts)
    }
  end

  defp api_url(opts),
    do:
      opts[:api] || build_url(opts[:domain], "api", opts[:api_version]) ||
        "https://#{Env.api_domain()}"

  defp fax_url(opts), do: opts[:fax] || build_url(opts[:domain], "fax", "v1") || Env.fax_url()

  defp task_router_url(opts),
    do:
      opts[:task_router] || build_url(opts[:domain], "taskrouter", "v1") || Env.task_router_url()

  defp task_router_websocket_url(opts),
    do:
      opts[:task_router_websocket] || build_url(opts[:domain], "event-bridge", "v1/wschannels") ||
        Env.task_router_websocket_base_url()

  defp programmable_chat_url(opts),
    do:
      opts[:programmable_chat] || build_url(opts[:domain], "chat", "v2") ||
        Env.programmable_chat_url()

  defp notify_url(opts),
    do: opts[:notify] || build_url(opts[:domain], "notify", "v1") || Env.notify_url()

  defp studio_url(opts),
    do: opts[:studio] || build_url(opts[:domain], "studio", "v1") || Env.studio_url()

  defp video_url(opts),
    do: opts[:video] || build_url(opts[:domain], "video", "v1") || Env.video_url()

  defp build_url(nil, _subdomain, _version), do: nil
  defp build_url(domain, subdomain, version), do: "https://#{subdomain}.#{domain}/#{version}"
end
