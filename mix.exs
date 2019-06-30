defmodule Decidex.MixProject do
  use Mix.Project

  @version "0.0.2"
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
      name: "Decidex",
      docs: [
        source_ref: "v#{@version}",
        source_url: "https://github.com/Lakret/decidex"
      ]
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["Apache 2"],
      maintainers: ["Dmitry Slutsky"],
      links: %{"GitHub" => "https://github.com/Lakret/decidex"}
    }
  end
end
