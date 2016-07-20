defmodule ExTwilio.Resource do
  @moduledoc """
  Mixin to include `ExTwilio.Api` module functionality in a module with slightly
  prettier syntax. Under the hood, it delegates all the work to other `ExTwilio`
  modules, primarily `ExTwilio.Api`.

  ## Example

  Define a module, and `use ExTwilio.Resource`.

      defmodule ExTwilio.Call do
        use ExTwilio.Resource, import: [:stream, :all]

        defstruct sid: nil, ...
      end

  The `import` option specifies which methods you want to be able to use.
  """

  @doc false
  defmacro __using__(options) do
    import_functions  = options[:import] || []
    quote bind_quoted: [import_functions: import_functions] do
      alias ExTwilio.Api
      alias ExTwilio.Parser
      alias ExTwilio.UrlGenerator, as: Url
      alias ExTwilio.ResultStream

      @spec new :: %__MODULE__{}
      def new, do: %__MODULE__{}

      @spec new(list) :: %__MODULE__{}
      def new(attrs) do
        do_new %__MODULE__{}, attrs
      end

      @spec do_new(%__MODULE__{}, list) :: %__MODULE__{}
      defp do_new(struct, []), do: struct
      defp do_new(struct, [{key, val}|tail]) do
        do_new Map.put(struct, key, val), tail
      end

      if :stream in import_functions do
        def stream(options \\ []), do: ResultStream.new(__MODULE__, options)
      end

      if :all in import_functions do
        @spec all(list) :: [map]
        def all(options \\ []), do: stream(options) |> Enum.into([])
      end

      if :find in import_functions do
        @spec find(String.t | nil, list) :: Parser.parsed_list_response
        def find(sid, options \\ []), do: Api.find(__MODULE__, sid, options)
      end

      if :create in import_functions do
        @spec create(Api.data, list) :: Parser.parsed_response
        def create(data, options \\ []), do: Api.create(__MODULE__, data, options)
      end

      if :update in import_functions do
        @spec update(String.t, Api.data, list) :: Parser.parsed_response
        def update(sid, data, options \\ []), do: Api.update(__MODULE__, sid, data, options)
      end

      if :destroy in import_functions do
        @spec destroy(String.t, list) :: Parser.success_delete | Parser.error
        def destroy(sid, options \\ []), do: Api.destroy(__MODULE__, sid, options)
      end

      @doc """
      Underscored and lowercased collection name for a given resource.
      Delegates the real work to `ExTwilio.Api.resource_collection_name/1` by
      default.

      Override in your module before `use ExTwilio.Resource` if you need
      something different.
      """
      def resource_collection_name, do: Url.resource_collection_name(__MODULE__)

      @doc """
      CamelCase resource name as it would be used in Twilio's API. Delegates
      the real work to `ExTwilio.Api.resource_name/1` by default.

      Override in your module before `use ExTwilio.Resource` if you need
      something different.
      """
      def resource_name, do: Url.resource_name(__MODULE__)

      @spec parents :: list
      def parents, do: []

      @spec children :: list
      def children, do: []

      defoverridable Module.definitions_in(__MODULE__)
    end
  end
end
