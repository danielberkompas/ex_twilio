defmodule ExTwilio.Parent do
  @moduledoc """
  This module provides structure for the specification of parents to a resource. It contains
  a `module` which should be the full module name of the parent resource, as well as a key
  which represents the key that will be matched against the options list to find the `sid` of the
  parent resource and place it into the url correctly.
  """
  defstruct module: nil,
            key: nil
end
