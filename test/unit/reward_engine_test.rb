require "test/unit"

class RewardEngineTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @engine = RewardEngine.new
  end

  def test_joe_six_pack_reward
    reward = @engine.evaluate(1, 1)
    assert_not_nil(reward, "reward should be not nil")

  end
  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end