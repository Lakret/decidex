defmodule Decidex.MixProject do
  use Mix.Project

  @version "0.0.1"
  @description "A small and simple decision tree learning library"

  def project do
    [
      app: :decidex,
      version: @version,
      description: @description,
      elixir: "~> 1.8",
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      package: package(),
      name: "Decidex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["Apache 2"],
      maintainers: ["Dmitry Slutsky"],
      links: %{"GitHub" => "https://github.com/Lakret/decidex"},
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "src", ".formatter.exs"]
    }
  end
end
