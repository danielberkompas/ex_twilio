defmodule ExTwilio.Mixfile do
  use Mix.Project

  @source_url "https://github.com/danielberkompas/ex_twilio"
  @version "0.10.0"

  def project do
    [
      app: :ex_twilio,
      version: @version,
      elixir: "~> 1.2",
      name: "ExTwilio",
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, ">= 0.9.0"},
      {:jason, "~> 1.2"},
      {:inflex, "~> 2.0"},
      {:joken, "~> 2.0"},
      {:dialyze, "~> 0.2.0", only: [:dev, :test]},
      {:mock, "~> 0.3", only: :test},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "CONTRIBUTING.md": [title: "Contributing"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
        "CALLING_TUTORIAL.md": [title: "Calling Tutorial"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"],
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Twilio API library for Elixir",
      maintainers: ["Daniel Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/ex_twilio/changelog.html",
        "Github" => @source_url
      }
    ]
  end
end
