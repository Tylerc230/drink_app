require "test/unit"

class RewardEngineTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @engine = RewardEngine.new 1 #user id
    drinks = {
        1 => 'beer, budweiser, domestic', #budweiser
        2 => 'beer, coors, domestic',
        3 => 'mimosa, fruity'
    }
    drinks.each{ |id, tags|
      drink = Drink.find(id)
      drink.tag_list = tags
      drink.save
    }
  end

  test "has 5 beers ever needs 6 for reward" do
    drink_id = 1
    count = 1
    checkin_time = 43200 #noon
    rewards = @engine.evaluate(drink_id, count, checkin_time)
    assert_not_nil(rewards, "reward should be not nil")
    assert_equal(1, rewards.length, "There should only be one reward")
    assert_equal(1, rewards.last.id, "Should be the joe six pack reward")

  end

  test "mimosas before 1pm reward" do
    drink_id = 3
    count = 1
    before_1pm_checkin_time = 43200 #noon
    rewards = @engine.evaluate(drink_id, count, before_1pm_checkin_time)
    assert_not_nil(rewards, "reward should be not nil")
    assert_equal(1, rewards.length, "There should only be one reward")
    assert_equal(2, rewards.last.id, "Should be the bottomless mimosas reward")

    after_1pm_checkin_time =  50400 #2pm
    rewards = @engine.evaluate(drink_id, count, after_1pm_checkin_time)
    assert_nil(rewards, "No rewards returned if checkin after 1pm")

    lexicographically_lower =  10000000 #2pm
    rewards = @engine.evaluate(drink_id, count, lexicographically_lower)
    assert_nil(rewards, "lexicographically lower, but numerically higher numbers should return no rewards")
  end

  def teardown
    # Do nothing
  end

end