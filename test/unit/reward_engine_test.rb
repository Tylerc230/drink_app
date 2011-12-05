require "test/unit"

class RewardEngineTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @engine = RewardEngine.new 1 #user id
    drink = Drink.find(1)#budweiser
    drink.tag_list = 'beer, budweiser, domestic'
    drink.save
  end

  test "has 5 beers needs 6 for reward" do
    drink_id = 1
    count = 1
    rewards = @engine.evaluate(drink_id, count)
    assert_not_nil(rewards, "reward should be not nil")
    assert_equal(1, rewards.length, "There should only be one reward")
    assert_equal(1, rewards.last.id, "Should be the joe six pack reward")

  end
  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end