defmodule ExTwilio.Resource do
  @moduledoc """
  Mixin to include `ExTwilio.Api` module functionality in a module with slightly
  prettier syntax. Under the hood, it delegates all the work to `ExTwilio.Api`.

  ## Example

  Define a module, and `use ExTwilio.Resource`.

      defmodule ExTwilio.Call do
        use ExTwilio.Resource, import: [:stream, :all, :list]

        defstruct sid: nil, ...
      end

  The `import` option specifies which of the `ExTwilio.Api` methods you want to
  be able to use. Under the hood, this creates three methods on your new module,
  and they look like this:

      def stream(options \\ []), do: Api.stream(__MODULE__, options)
      def all(options \\ []),    do: Api.all(__MODULE__, options)
      def list(options \\ []),   do: Api.list(__MODULE__, options)

  As you can see, they're simple aliases to `Api` methods. However, they do make
  your code look a lot nicer.

      # Instead of this:
      ExTwilio.Api.all(ExTwilio.Call)

      # You can write:
      ExTwilio.Call.all

  **Important**: You must define a struct for each module in which you `use
  ExTwilio.Resource`. Items from Twilio will be converted into instances of
  this struct.
  """

  @doc """
  Provide a `use` macro for use extending.
  """
  defmacro __using__(options) do
    import_functions  = options[:import] || []
    quote bind_quoted: [import_functions: import_functions] do
      alias ExTwilio.Api
      alias ExTwilio.Parser

      module   = String.replace(to_string(__MODULE__), ~r/Elixir\./, "")
      resource = String.replace(module, ~r/ExTwilio\./, "")
      variable = String.downcase(resource) |> Inflex.pluralize
      variable_singular = Inflex.singularize(variable)

      if Enum.member? import_functions, :stream do
        @doc """
        Create a stream of all #{resource} records from the Twilio API.

        Delegates to `ExTwilio.Api.stream/2`.
        """
        @spec stream(list) :: Enumerable.t
        def stream(options \\ []), do: Api.stream(__MODULE__, options)
      end

      if Enum.member? import_functions, :all do
        @doc """
        Retrieve _all_ of the #{resource} records from the Twilio API, paging
        through all the API response pages.

        Delegates to `ExTwilio.Api.all/2`.

        ## Examples

            #{variable} = #{module}.all
        """
        @spec all(list) :: [map]
        def all(options \\ []), do: Api.all(__MODULE__, options)
      end

      if Enum.member? import_functions, :list do
        @doc """
        Retrieve a list of #{Inflex.pluralize resource} from the API. 

        Delegates to `ExTwilio.Api.list/2`.

        ## Examples

            # Successful response
            {:ok, #{variable}, metadata} = #{module}.list

            # Error response
            {:error, msg, http_code} = #{module}.list
        """
        @spec list(list) :: Parser.parsed_list_response
        def list(options \\ []), do: Api.list(__MODULE__, options)

        @doc """
        Get the next page of #{variable}, using the metadata from the previous
        response. See `all/0` for an easy way to get all the records.

        Delegates to `ExTwilio.Api.fetch_page/2`.

        ## Examples

            {:ok, page1, meta} = #{module}.list
            {:ok, page2, meta} = #{module}.next_page(meta)
        """
        @spec next_page(map) :: Parser.parsed_list_response
        def next_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["next_page_uri"])
        end

        @doc """
        Get the previous page of #{variable}, using metadata from a previous 
        response.

        Delegates to `ExTwilio.Api.fetch_page/2`.

        ## Examples

            {:ok, page2, meta} = #{module}.list(page: 2)
            {:ok, page1, meta} = #{module}.previous_page(meta)
        """
        @spec previous_page(map) :: Parser.parsed_list_response
        def previous_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["previous_page_uri"])
        end

        @doc """
        Get the first page of #{variable}, using metadata from any page's 
        response.

        Delegates to `ExTwilio.Api.fetch_page/2`.

        ## Examples

            {:ok, page10, meta} = #{module}.list(page: 10)
            {:ok, page1, meta}  = #{module}.first_page(meta)
        """
        @spec first_page(map) :: Parser.parsed_list_response
        def first_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["first_page_uri"])
        end

        @doc """
        Get the last page of #{variable}, using metadta from any page's 
        response.

        Delegates to `ExTwilio.Api.fetch_page/2`.

        ## Examples
            
            {:ok, page10, meta}    = #{module}.list(page: 10)
            {:ok, last_page, meta} = #{module}.last_page(meta)
        """
        @spec last_page(map) :: Parser.parsed_list_response
        def last_page(metadata) do
          Api.fetch_page(__MODULE__, metadata["last_page_uri"])
        end
      end

      if Enum.member? import_functions, :find do
        @doc """
        Find any #{resource} by its Twilio SID.

        Delegates to `ExTwilio.Api.find/3`.

        ## Examples

            {:ok, #{variable_singular}} = #{module}.find("...")
            {:error, msg, http_status} = #{module}.find("...")
        """
        @spec find(String.t, list) :: Parser.parsed_list_response
        def find(sid, options \\ []), do: Api.find(__MODULE__, sid, options)
      end

      if Enum.member? import_functions, :create do
        @doc """
        Create a new #{resource} in the Twilio API. Any field supported by
        Twilio's #{resource} API can be passed in the 'data' keyword list.

        Delegates to `ExTwilio.Api.create/3`.
        """
        @spec create(list, list) :: Parser.parsed_response
        def create(data, options \\ []), do: Api.create(__MODULE__, data, options)
      end

      if Enum.member? import_functions, :update do
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

      if Enum.member? import_functions, :destroy do
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
      def resource_collection_name, do: Api.resource_collection_name(__MODULE__)

      @doc """
      CamelCase resource name as it would be used in Twilio's API. Delegates
      the real work to `ExTwilio.Api.resource_name/1` by default.

      Override in your module before `use ExTwilio.Resource` if you need
      something different.
      """
      def resource_name, do: Api.resource_name(__MODULE__)
    end
  end
end
