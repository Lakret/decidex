defmodule Decidex do
  @moduledoc """
  A decision tree library for small datasets.
  """

  @typedoc """
  A [feature](https://en.wikipedia.org/wiki/Feature_(machine_learning)) - a parameter of the data.
  """
  @type feature :: any

  @typedoc """
  A value of some `feature`.
  """
  @type feature_value :: any

  @typedoc """
  A predicted or actual outcome for an example feature vector `features`.
  """
  @type outcome :: any

  @typedoc """
  A decision tree.

  Represented as a recursive data structure, each node of which can either be an `outcome`,
  or a tuple of a `feature` and a map from all possible `feature_value`s to subtrees or `outcome`s.
  """
  @type t :: {feature, %{feature_value => t | outcome}} | outcome

  @typedoc """
  A [feature vector](https://en.wikipedia.org/wiki/Feature_(machine_learning)).

  Represented as a map from `feature` to corresponding `feature_value`.
  """
  @type features :: %{feature => feature_value}

  @typedoc """
  A training dataset.

  Represented as a list of tuples of `features` (feature vectors) and `outcome`s.
  """
  @type training_data :: [{features, outcome}]

  @doc """
  Predicts the outcome for `features` feature vector using `decision_tree`.

  Returns an `outcome`.
  """
  @spec predict(decision_tree :: t, features :: features) :: outcome
  def predict(decision_tree, features)

  def predict({feature, value_to_subtree_or_outcome}, features) do
    feature_value = Map.fetch!(features, feature)
    subtree_or_outcome = Map.fetch!(value_to_subtree_or_outcome, feature_value)
    predict(subtree_or_outcome, features)
  end

  # base case - reached a leaf, returning the expected `outcome`
  def predict(outcome, _features), do: outcome

  @doc """
  Learns a decision tree from `training_data`.

  You can switch learning algorithm using `opts` parameter `:algorithm`.
  By default it's set to `Decidex.LearningAlgorithms.ID3`.

  Returns the learned decision tree.
  """
  @spec learn(training_data, opts :: Keyword.t()) :: t()
  def learn(training_data, opts \\ []) do
    learning_algorithm_module = Keyword.get(opts, :algorithm, Decidex.LearningAlgorithms.ID3)
    learning_algorithm_module.learn(training_data)
  end

  ## Quick-start examples

  @doc """
  An example decision tree.

  This is a slightly modified example from
  [these slides](http://www.ke.tu-darmstadt.de/lehre/archiv/ws0809/mldm/dt.pdf).
  """
  @spec example :: t()
  def example() do
    {:weather?,
     %{
       sunny: {:humidity?, %{normal: :yes, high: :no}},
       cloudy: :yes,
       rain: {:windy?, %{true: :no, false: :yes}}
     }}
  end

  @doc """
  An example training dataset.

  This is a slightly modified example from
  [these slides](http://www.ke.tu-darmstadt.de/lehre/archiv/ws0809/mldm/dt.pdf).
  """
  @spec example_training_data :: training_data
  def example_training_data() do
    [
      {%{weather?: :sunny, humidity?: :high, windy?: false}, :no},
      {%{weather?: :sunny, humidity?: :high, windy?: true}, :no},
      {%{weather?: :cloudy, humidity?: :high, windy?: false}, :yes},
      {%{weather?: :rain, humidity?: :normal, windy?: false}, :yes},
      {%{weather?: :cloudy, humidity?: :normal, windy?: true}, :yes},
      {%{weather?: :sunny, humidity?: :high, windy?: false}, :no},
      {%{weather?: :sunny, humidity?: :normal, windy?: false}, :yes},
      {%{weather?: :rain, humidity?: :normal, windy?: false}, :yes},
      {%{weather?: :sunny, humidity?: :normal, windy?: true}, :yes},
      {%{weather?: :cloudy, humidity?: :high, windy?: true}, :yes},
      {%{weather?: :cloudy, humidity?: :normal, windy?: false}, :yes},
      {%{weather?: :rain, humidity?: :high, windy?: true}, :no},
      {%{weather?: :rain, humidity?: :normal, windy?: true}, :no},
      {%{weather?: :rain, humidity?: :high, windy?: false}, :yes}
    ]
  end
end
