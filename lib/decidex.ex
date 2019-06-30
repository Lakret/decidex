defmodule Decidex do
  @type feature :: any
  @type feature_value :: any
  @type outcome :: any

  @type t :: {feature, %{feature_value => t | outcome}} | outcome

  @type feature_vector :: %{feature => feature_value}
  @type training_data :: [{feature_vector, outcome}]

  @spec example :: t()
  def example() do
    {:weather?,
     %{
       sunny: {:humidity?, %{normal: :yes, high: :no}},
       cloudy: :yes,
       rain: {:windy?, %{true: :no, false: :yes}}
     }}
  end

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

  @doc """
  Predicts the outcome for `feature_vector` using `decision_tree`.

  Returns an `outcome`.
  """
  @spec predict(t, feature_vector) :: outcome
  def predict(decision_tree, feature_vector)

  def predict({feature, value_to_subtree_or_outcome}, feature_vector) do
    feature_value = Map.fetch!(feature_vector, feature)
    subtree_or_outcome = Map.fetch!(value_to_subtree_or_outcome, feature_value)
    predict(subtree_or_outcome, feature_vector)
  end

  def predict(outcome, _feature_vector), do: outcome

  @spec learn(training_data, opts :: Keyword.t()) :: t()
  def learn(training_data, opts \\ []) do
    learning_algorithm_module = Keyword.get(opts, :algorithm, Decidex.LearningAlgorithms.ID3)
    learning_algorithm_module.learn(training_data)
  end
end
