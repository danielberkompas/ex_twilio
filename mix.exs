defmodule ExTwilio.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_twilio,
     version: "0.2.1",
     elixir: "~> 1.2",
     name: "ExTwilio",
     description: "Twilio API library for Elixir",
     source_url: "https://github.com/danielberkompas/ex_twilio",
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :inflex, :poison, :joken]]
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
      {:httpoison, ">= 0.9.0"},
      {:poison, "~> 2.2"},
      {:inflex, "~> 1.0"},
      {:joken, "~> 1.3.1"},
      {:dialyze, "~> 0.2.0", only: [:dev, :test]},
      {:credo, "~> 0.5.1", only: [:dev, :test]},
      {:mock, "~> 0.2.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  def docs do
    [
      readme: "README.md",
      main: ExTwilio
    ]
  end

  defp package do
    [
      maintainers: ["Daniel Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/danielberkompas/ex_twilio"
      }
    ]
  end
end
