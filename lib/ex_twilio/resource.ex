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

  @doc """
  Provide a `use` macro for use extending.
  """
  defmacro __using__(options) do
    import_functions  = options[:import] || []
    quote bind_quoted: [import_functions: import_functions] do
      alias ExTwilio.Api
      alias ExTwilio.Parser
      alias ExTwilio.UrlGenerator, as: Url
      alias ExTwilio.ResultStream

      module   = String.replace(to_string(__MODULE__), ~r/Elixir\./, "")
      resource = String.replace(module, ~r/ExTwilio\./, "")
      variable = String.downcase(resource) |> Inflex.pluralize
      variable_singular = Inflex.singularize(variable)

      @doc """
      Creates a new #{module} struct. Optionally, you can pass in attributes to
      set their initial value in the struct.

      ## Example

          %#{module}{} = #{module}.new
          %#{module}{sid: "sid"} = #{module}.new(sid: "sid")
      """
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
        @doc """
        Create an `ExTwilio.ResultStream` of all #{resource} records from the 
        Twilio API.
        """
        def stream(options \\ []), do: ResultStream.new(__MODULE__, options)
      end

      if :all in import_functions do
        @doc """
        Retrieve _all_ of the #{resource} records from the Twilio API, paging
        through all the API response pages.

        Delegates to `ExTwilio.Api.all/2`.

        ## Examples

            #{variable} = #{module}.all
        """
        @spec all(list) :: [map]
        def all(options \\ []), do: stream(options) |> Enum.into([])
      end

      if :find in import_functions do
        @doc """
        Find any #{resource} by its Twilio SID.

        Delegates to `ExTwilio.Api.find/3`.

        ## Examples

            {:ok, #{variable_singular}} = #{module}.find("...")
            {:error, msg, http_status} = #{module}.find("...")
        """
        @spec find(String.t | nil, list) :: Parser.parsed_list_response
        def find(sid, options \\ []), do: Api.find(__MODULE__, sid, options)
      end

      if :create in import_functions do
        @doc """
        Create a new #{resource} in the Twilio API. Any field supported by
        Twilio's #{resource} API can be passed in the 'data' keyword list.

        Delegates to `ExTwilio.Api.create/3`.
        """
        @spec create(list, list) :: Parser.parsed_response
        def create(data, options \\ []), do: Api.create(__MODULE__, data, options)
      end

      if :update in import_functions do
        @doc """
        Update an #{resource} in the Twilio API. You can pass it a binary SID as
        the identifier, or a whole %#{module}{} struct.

        Delegates to `ExTwilio.Api.update/4`.

        ## Examples

            {:ok, #{variable_singular}} = #{module}.update(%#{module}{...}, field: "new_value")
            {:ok, #{variable_singular}} = #{module}.update("<SID HERE>", field: "new_value")
        """
        @spec update(String.t, list, list) :: Parser.parsed_response
        def update(sid, data, options \\ []), do: Api.update(__MODULE__, sid, data, options)
      end

      if :destroy in import_functions do
        @doc """
        Delete any #{resource} from your Twilio account, using its SID.

        Delegates to `ExTwilio.Api.destroy/3`.
        """
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
