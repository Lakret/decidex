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
    {:decidex, "~> 0.0.2"}
  ]
end
```

Docs are available [on Hex.pm](https://hexdocs.pm/decidex/0.0.2).

## Quick start

First, let's look at the example training dataset:

```elixir
iex> import Decidex
iex> example_training_data()
[
  {%{humidity?: :high, weather?: :sunny, windy?: false}, :no},
  {%{humidity?: :high, weather?: :sunny, windy?: true}, :no},
  {%{humidity?: :high, weather?: :cloudy, windy?: false}, :yes},
  ...
]
```

As you can see, each training example is a tuple. The first element is a map corresponding to a feature vector - i.e.,
mapping each feature (attribute, parameter, measurement, ...) to its value for this particular example. The second element is
an `outcome` - a value that we will attempt to predict using decision trees.

In this example, we decide if we want to play golf, depending on the weather. Thus, our outcomes are either `:yes` (play)
or `:no` (don't play). The features we are considering are `:humidity?` (with possible values `:high` and `:normal`),
`:weather?` (with possible values `:sunny`, `:cloudy`, and `:rain`), and `:windy?` (with possible values `true` and `false`).

To learn a decision tree from this example training dataset, we can use `learn/1` function:

```elixir
iex> tree = learn(example_training_data())
{:weather?,
 %{
   cloudy: :yes,
   rain: {:windy?, %{false: :yes, true: :no}},
   sunny: {:humidity?, %{high: :no, normal: :yes}}
 }}
```

We can draw this tree to make it a bit more understandable:

![Decision tree](https://raw.githubusercontent.com/Lakret/decidex/master/priv/images/golf_decision_tree.png)

We can use the learned decision tree to make predictions with the help of `predict/2` function:

```elixir
iex> predict(tree, %{windy?: true, weather?: :sunny, humidity?: :normal})
:yes
```

Finally, to reuse the learned decision tree we can easily save it using erlang binary format:

```elixir
iex> serialized_tree = :erlang.term_to_binary(tree)
iex> File.write!("my_golf_tree.bin", serialized_tree, [:binary])
```

And then read it:

```elixir
iex> File.read!("my_golf_tree.bin") |> :erlang.binary_to_term()
{:weather?,
 %{
   cloudy: :yes,
   rain: {:windy?, %{false: :yes, true: :no}},
   sunny: {:humidity?, %{high: :no, normal: :yes}}
 }}
```
