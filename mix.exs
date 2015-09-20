defmodule ExTwilio.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_twilio,
     version: "0.1.1",
     elixir: "~> 1.0",
     name: "ExTwilio",
     description: "Twilio API library for Elixir",
     source_url: "https://github.com/danielberkompas/ex_twilio",
     package: package,
     docs: docs,
     dialyzer: [
       plt_file: "#{System.get_env("HOME")}/#{plt_filename}",
       flags: ["--no_native", "-Wno_match", "-Wno_return"]
     ],
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
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
      {:poison, "~> 1.4"},
      {:inflex, "~> 1.0.0"},
      {:mock, "~> 0.1.0", only: :test},
      {:ex_doc, "~> 0.7", only: :docs},
      {:inch_ex, only: :docs}
    ]
  end

  def docs do
    [
      readme: "README.md",
      main: ExTwilio
    ]
  end

  defp plt_filename do
    "elixir-#{System.version}_#{otp_release}.plt"
  end

  defp otp_release do
    case System.get_env("TRAVIS_OTP_RELEASE") do
      nil     -> :erlang.system_info(:otp_release)
      release -> release
    end
  end

  defp package do
    [
      contributors: ["Daniel Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/danielberkompas/ex_twilio"
      }
    ]
  end
end
