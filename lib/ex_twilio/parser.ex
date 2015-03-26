defmodule ExTwilio.Parser do
  @type metadata         :: map
  @type http_status_code :: number
  @type key              :: String.t
  @type response         :: %{body: String.t, status_code: number}
  @type success          :: {:ok, [map]}
  @type success_list     :: {:ok, [map], metadata}
  @type success_delete   :: :ok
  @type error            :: {:error, String.t, http_status_code}

  @spec parse(atom, response) :: success | error
  def parse(module, response) do
    handle_errors response, fn(body) ->
      Poison.decode!(body, as: module)
    end
  end

  @spec parse_list(atom, response, key) :: success_list | error
  def parse_list(module, response, key) do
    result = handle_errors response, fn(body) ->
      as = Dict.put(%{}, key, [module])
      Poison.decode!(body, as: as)
    end

    case result do
      {:ok, list} -> {:ok, list[key], Dict.drop(list, [key])}
      error       -> error
    end
  end

  @spec handle_errors(response, ((String.t) -> any)) :: success | success_delete | error
  defp handle_errors(response, fun) do
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
