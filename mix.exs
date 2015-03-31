defmodule ExTwilio.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_twilio,
     version: "0.0.1",
     elixir: "~> 1.0",
     name: "ExTwilio",
     source_url: "https://github.com/danielberkompas/ex_twilio",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :ibrowse, :httpotion]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.7"},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
      {:httpotion, github: "myfreeweb/httpotion"},
      {:mock, "~> 0.1.0"},
      {:poison, "~> 1.3.1"},
      {:inflex, "~> 1.0.0"},
      {:inch_ex, only: :docs}
    ]
  end
end
