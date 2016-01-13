defmodule ExTwilio.ResultStream do
  @moduledoc """
  Generate a stream of results for a given Twilio API URL. Pages are lazily
  loaded on demand.

  ## Example

      ExTwilio.ResultStream.new(ExTwilio.Call)
      |> Stream.map(fn call -> call.sid end)
      |> Enum.take(5)

      # => [%ExTwilio.Call{ ... }, %ExTwilio.Call{ ... }, ...]
  """

  alias ExTwilio.Api
  alias ExTwilio.Parser
  alias ExTwilio.UrlGenerator

  @type url :: String.t

  @doc """
  Create a new Stream.

  ## Parameters

  - `module`: The name of the module to create a Stream of results for.

  ## Example

      ExTwilio.ResultStream.new(ExTwilio.Call)
  """
  def new(module, options \\ []) do
    url = UrlGenerator.build_url(module, nil, options)

    Stream.resource(
      fn -> fetch_page(url, module) end,
      &process_page/1,
      fn _ -> nil end
    )
  end

  @spec fetch_page(url, module) :: {list, url, module}
  defp fetch_page(url, module) do
    results = Api.get(url)
    {:ok, items, meta} = Parser.parse_list(results, module, module.resource_collection_name)
    {items, meta["next_page_uri"], module}
  end

  @spec process_page({list | nil, url | nil, module}) :: {:halt, nil} |
                                                         {list, {nil, url, module}}
  defp process_page({nil, nil, _module}) do
    {:halt, nil}
  end

  defp process_page({nil, next_page_url, module}) do
    next_page_url
    |> fetch_page(module)
    |> process_page
  end

  defp process_page({items, next_page_url, module}) do
    {items, {nil, next_page_url, module}}
  end
end
