defmodule ExTwilio.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_twilio,
      version: "0.8.2",
      elixir: "~> 1.2",
      name: "ExTwilio",
      description: "Twilio API library for Elixir",
      source_url: "https://github.com/danielberkompas/ex_twilio",
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger, :httpoison, :inflex, :poison, :joken]]
  end

  defp deps do
    [
      {:httpoison, ">= 0.9.0"},
      {:poison, ">= 3.0.0"},
      {:inflex, "~> 2.0"},
      {:joken, "~> 2.0"},
      {:dialyze, "~> 0.2.0", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]}
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
