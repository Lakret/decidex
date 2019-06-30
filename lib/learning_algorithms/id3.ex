defmodule Decidex.LearningAlgorithms.ID3 do
  @moduledoc """
  TODO:
  """
  require Logger

  @spec learn(training_data :: Decidex.training_data()) :: Decidex.t()
  def learn(training_data) do
    learn(training_data, features(training_data))
  end

  @spec features(training_data :: Decidex.training_data()) :: [Decidex.feature()]
  defp features([] = _training_data) do
    raise ArgumentError, "cannot extract features from empty `training_data`"
  end

  defp features(training_data) when is_list(training_data) do
    {feature_vector, _outcome} = hd(training_data)
    Map.keys(feature_vector)
  end

  @spec learn(Decidex.training_data(), [Decidex.feature()]) :: Decidex.t()
  defp learn(training_data, features)
       when is_list(training_data) and length(training_data) > 0 and is_list(features) do
    outcomes = Enum.map(training_data, fn {_feature_vector, outcome} -> outcome end)

    case Enum.uniq(outcomes) do
      # base case - if all examples return the same outcome, return it as predicted
      [same_outcome] ->
        # Logger.debug(
        #   "only one outcome in training dataset of length = #{length(training_data)}:" <>
        #     "[#{inspect(same_outcome)}]"
        # )

        same_outcome

      _several_outcomes ->
        max_information_gain_feature = Enum.max_by(features, &information_gain(&1, training_data))
        # Logger.debug("max information gain feature: #{inspect(max_information_gain_feature)}")

        max_information_gain_feature_values = feature_values(max_information_gain_feature, training_data)
        # Logger.debug("max information gain feature values: #{inspect(max_information_gain_feature_values)}")
        features = List.delete(features, max_information_gain_feature)
        # Logger.debug("remaining features: #{inspect(features)}")

        subtrees =
          Enum.map(
            max_information_gain_feature_values,
            fn feature_value ->
              subtree =
                subset_with_feature_value(training_data, max_information_gain_feature, feature_value)
                |> learn(features)

              {feature_value, subtree}
            end
          )
          |> Enum.into(%{})

        {max_information_gain_feature, subtrees}
    end
  end

  @doc """
  Calculates information gain for `feature` on `training_data`.
  """
  @spec information_gain(feature :: Decidex.feature(), training_data :: Decidex.training_data()) ::
          number
  def information_gain(feature, training_data) do
    original_entropy = entropy(training_data)
    sample_size = length(training_data)

    after_split_entropy =
      feature_values(feature, training_data)
      |> Enum.map(&subset_with_feature_value(training_data, feature, &1))
      |> Enum.map(fn subset ->
        length(subset) / sample_size * entropy(subset)
      end)
      |> Enum.sum()

    ig = original_entropy - after_split_entropy
    Logger.debug("ig(#{inspect(feature)}) = #{ig}")
    ig
  end

  @doc """
  Calculates entropy of `training_data`.

  See [Wikipedia article](https://en.wikipedia.org/wiki/ID3_algorithm#Entropy)
  for in-depth explanation.
  """
  @spec entropy(training_data :: Decidex.training_data()) :: number()
  def entropy(training_data) do
    outcome_counts =
      Enum.reduce(training_data, %{}, fn {_features, outcome}, outcome_counts ->
        Map.update(outcome_counts, outcome, 1, &(&1 + 1))
      end)

    sample_size = length(training_data)

    Enum.map(outcome_counts, fn {_outcome, count} ->
      probability = count / sample_size
      -probability * :math.log2(probability)
    end)
    |> Enum.sum()
  end

  @spec feature_values(Decidex.feature(), Decidex.training_data()) :: [Decidex.feature_value()]
  defp feature_values(_feature, [] = _training_data) do
    raise "programming error: tried to extract feature_values from empty `training_data`!"
  end

  defp feature_values(feature, training_data) when is_list(training_data) do
    Enum.map(training_data, fn {features, _outcome} -> features[feature] end)
    |> Enum.uniq()
  end

  defp subset_with_feature_value(training_data, feature, feature_value) do
    Enum.filter(training_data, fn {features, _outcome} -> features[feature] == feature_value end)
  end
end
