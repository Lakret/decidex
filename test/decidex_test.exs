defmodule DecidexTest do
  use ExUnit.Case
  import Decidex

  doctest Decidex

  test "`predict` works" do
    {features, actual_outcome} = hd(example_training_data())
    expected_outcome = predict(example(), features)

    assert actual_outcome == expected_outcome
  end

  test "`learn` works" do
    expected_tree = example()
    actual_tree = learn(example_training_data())

    assert actual_tree == expected_tree
  end
end
