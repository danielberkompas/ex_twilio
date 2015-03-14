defmodule ExTwilio.Parser do
  defmacro __using__(_) do
    quote do
      def parse(response) do
        handle_errors response, fn(body) ->
          Poison.decode!(body, as: __MODULE__)
        end
      end

      def parse_list(response, key) do
        result = handle_errors response, fn(body) ->
          as = Dict.put(%{}, key, [__MODULE__])
          Poison.decode!(body, as: as)
        end

        case result do
          {:ok, list} -> {:ok, list[key], Dict.drop(list, [key])}
          error       -> error
        end
      end

      def handle_errors(response, fun) do
        case response do
          %{body: body, status_code: status} when status in [200, 201] -> 
            {:ok, fun.(body)}

          %{body: _, status_code: 204} ->
            :ok

          %{body: body, status_code: status} -> 
            {:ok, json} = Poison.decode(body)
            {:error, json["message"], status}
        end
      end
    end
  end
end
