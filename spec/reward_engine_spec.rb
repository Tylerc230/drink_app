require "rspec"
require "spec_helper.rb"
require "reward_engine"

describe "Evaluate Rewards" do
  before :each do
    create_beer
    create_mimosa
    create_joe_sixpack
    create_bottomless_mimosa
    @engine = RewardEngine.new 1 #user id
  end

  it "should grant reward for 6th beer this session" do
    rewards = create_one_beer_checkin_at_time Checkin::SESSION_DIVIDER - 1.hour
    rewards.should_not be_nil
    rewards.should have(1).reward
    reward = rewards.last
    reward.id.should eql(@six_pack_reward.id)

  end

  it "should not grant reward for 6th beer out of session" do
    rewards = create_one_beer_checkin_at_time Checkin::SESSION_DIVIDER + 1.hour
    rewards.should be_nil
  end

  def create_one_beer_checkin_at_time time
    Factory.create_list(:checkin, 5, :drink_id => @budweiser.id, :checkin_time => 0.hours)
    new_checkin = Factory.build(:checkin, :drink_id => @budweiser.id, :checkin_time => time)
    session_id = new_checkin.calculate_session_id
    @engine.evaluate(new_checkin.drink_id, new_checkin.count, new_checkin.checkin_time, session_id)
  end

  it "should grant bottomless_mimosa reward" do
    checkin_time = DateTime.new(2011, 12, 20) + 12.hours
    mimosa_checkin = Factory.build(:checkin, :drink => @mimosa, :checkin_time => checkin_time)
    rewards = @engine.evaluate(mimosa_checkin.drink_id, mimosa_checkin.count, mimosa_checkin.checkin_time, mimosa_checkin.session_id)
    rewards.should_not be_nil
    rewards.should have(1).reward
    rewards.last.should eq(@bottomless_mimosa_reward)
  end

  #  after_1pm_checkin_time =  50400 #2pm
  #  rewards = @engine.evaluate(drink_id, count, after_1pm_checkin_time)
  #  assert_nil(rewards, "No rewards returned if checkin after 1pm")
  #
  #  lexicographically_lower =  10000000 #2pm
  #  rewards = @engine.evaluate(drink_id, count, lexicographically_lower)
  #  assert_nil(rewards, "lexicographically lower, but numerically higher numbers should return no rewards")
  #end

end