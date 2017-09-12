defmodule Numero.Mixfile do
  use Mix.Project

  @version "0.1.3"

  def project do
    [app: :numero,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     # Docs
     name: "Numero",
     source_url: "https://github.com/alisinabh/Numero",
     homepage_url: "https://github.com/alisinabh/Numero",
     docs: [main: "readme", # The main page in the docs
           extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: []]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev, runtime: false}]
  end

  defp description do
    """
    A micro library for converting non-english digits.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :numero,
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Alisina Bahadori"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/alisinabh/Numero"}
    ]
  end
end
