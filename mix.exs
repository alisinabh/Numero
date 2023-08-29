defmodule Numero.Mixfile do
  use Mix.Project

  @version "0.3.1"

  def project do
    [
      app: :numero,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      package: package(),
      deps: deps(),
      # Docs
      name: "Numero",
      docs: [
        source_url: "https://github.com/alisinabh/Numero",
        homepage_url: "https://github.com/alisinabh/Numero",
        # The main page in the docs
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.30.6", only: :dev, runtime: false}]
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
