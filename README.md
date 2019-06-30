# Decidex

A small and simple decision tree learning library for using on small datasets in Elixir applications.

[Decision trees](https://en.wikipedia.org/wiki/Decision_tree) are one of the simplest machine learning models,
and though they don't perform nearly as good as more sophisticated classifiers on large datasets,
they have some important advantages for small usecases:

- you can inspect and explain decision tree - it's a white box model
- decision trees perform well on small to medium datasets - i.e., most datasets encountered in practical applications

These factors allow decision trees to be used to sparkle some intelligent logic inside larger applications without resorting to
whole data-processing pipelines and sophisticated machine learning.

## Installation

The package can be installed by adding `decidex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:decidex, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/decidex](https://hexdocs.pm/decidex).
