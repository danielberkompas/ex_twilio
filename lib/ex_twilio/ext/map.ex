defmodule ExTwilio.Ext.Map do
  @moduledoc """
  Additional helper functions for working with maps.
  """

  @type key :: atom | String.t()

  @doc """
  Puts a given key/value pair into a map, if the value is not `false` or `nil`.
  """
  @spec put_if(map, key, any) :: map
  def put_if(map, _key, value) when value in [nil, false] do
    map
  end

  def put_if(map, key, value) do
    Map.put(map, key, value)
  end

  @doc """
  Validates that a function returns true on the given map field, otherwise
  raises an error.
  """
  @spec validate!(map, key, function, message :: String.t()) :: map | no_return
  def validate!(map, field, fun, message) do
    value = Map.get(map, field)

    if fun.(value) do
      map
    else
      raise ArgumentError, "#{inspect(field)} #{message}, was: #{inspect(value)}"
    end
  end
end
