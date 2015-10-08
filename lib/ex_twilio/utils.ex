defmodule ExTwilio.Utils do
  @moduledoc """
  Provides `camelize/1` and `underscore/1` functions. Stolen from ExTwilio.Utils.
  """

  @doc """
  Converts the given atom or binary to underscore format.
  If an atom is given, it is assumed to be an Elixir module,
  so it is converted to a binary and then processed.

  ## Examples
      iex> ExTwilio.Utils.underscore "FooBar"
      "foo_bar"
      iex> ExTwilio.Utils.underscore "Foo.Bar"
      "foo/bar"
      iex> ExTwilio.Utils.underscore Foo.Bar
      "foo/bar"

  In general, `underscore` can be thought of as the reverse of
  `camelize`, however, in some cases formatting may be lost:

      iex> ExTwilio.Utils.underscore "SAPExample"
      "sap_example"
      iex> ExTwilio.Utils.camelize "sap_example"
      "SapExample"
  """
  def underscore(atom) when is_atom(atom) do
    "Elixir." <> rest = Atom.to_string(atom)
    underscore(rest)
  end

  def underscore(""), do: ""

  def underscore(<<h, t :: binary>>) do
    <<to_lower_char(h)>> <> do_underscore(t, h)
  end

  defp do_underscore(<<h, t, rest :: binary>>, _) when h in ?A..?Z and not (t in ?A..?Z or t == ?.) do
    <<?_, to_lower_char(h), t>> <> do_underscore(rest, t)
  end

  defp do_underscore(<<h, t :: binary>>, prev) when h in ?A..?Z and not prev in ?A..?Z do
    <<?_, to_lower_char(h)>> <> do_underscore(t, h)
  end

  defp do_underscore(<<?., t :: binary>>, _) do
    <<?/>> <> underscore(t)
  end

  defp do_underscore(<<h, t :: binary>>, _) do
    <<to_lower_char(h)>> <> do_underscore(t, h)
  end

  defp do_underscore(<<>>, _) do
    <<>>
  end

  @doc """
  Converts the given string to CamelCase format.

  ## Examples

      iex> ExTwilio.Utils.camelize "foo_bar"
      "FooBar"
  """
  @spec camelize(String.t) :: String.t  
  def camelize(string)

  def camelize(""),
    do: ""

  def camelize(<<?_, t :: binary>>),
    do: camelize(t)

  def camelize(<<h, t :: binary>>),
    do: <<to_upper_char(h)>> <> do_camelize(t)

  defp do_camelize(<<?_, ?_, t :: binary>>),
    do: do_camelize(<< ?_, t :: binary >>)

  defp do_camelize(<<?_, h, t :: binary>>) when h in ?a..?z,
    do: <<to_upper_char(h)>> <> do_camelize(t)

  defp do_camelize(<<?_>>),
    do: <<>>

  defp do_camelize(<<?/, t :: binary>>),
    do: <<?.>> <> camelize(t)

  defp do_camelize(<<h, t :: binary>>),
    do: <<h>> <> do_camelize(t)

  defp do_camelize(<<>>),
    do: <<>>

  defp to_upper_char(char) when char in ?a..?z, do: char - 32
  defp to_upper_char(char), do: char

  defp to_lower_char(char) when char in ?A..?Z, do: char + 32
  defp to_lower_char(char), do: char
end
