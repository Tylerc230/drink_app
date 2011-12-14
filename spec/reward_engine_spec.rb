require "rspec"
require "spec_helper.rb"
require "reward_engine"

describe "Evaluate Rewards" do
  before :each do
    Factory(:drink, :name => 'Budweiser', :tag_list => 'beer, budweiser, domestic')
    Factory(:drink, :name => 'Coors', :tag_list => 'beer, coors, domestic')
    Factory(:drink, :name => 'Mimosa', :tag_list => 'mimosa, fruity')

    six_pack_reward = Factory(:reward, :title => "Joe Six Pack!", :text => "Youve been awarded this award for drinking 6 beers")
    Factory(:reward_condition, :reward_id => six_pack_reward.id, :condition_type => RewardCondition::RC_DRINK_TYPE, :value => 'beer')
    Factory(:reward_condition, :reward_id => six_pack_reward.id, :condition_type => RewardCondition::RC_AMOUNT_PER_SESSION, :value => '6')

    bottomless_mimosa_reward = Factory(:reward, :title => "Bottomless Mimosas", :text => "You\'ve achieved bottomless mimosas")
    Factory(:reward_condition, :reward_id => bottomless_mimosa_reward.id, :condition_type => RewardCondition::RC_DRINK_TYPE, :value => 'mimosa')
    Factory(:reward_condition, :reward_id => bottomless_mimosa_reward.id, :condition_type => RewardCondition::RC_BEFORE_TIME, :value => '46800')
    @engine = RewardEngine.new 1 #user id
  end

  it "should grant reward for 6th beer" do
    drink_id = Drink.find_by_name('Budweiser').id
    count = 1
    checkin_time = 43200 #noon
    rewards = @engine.evaluate(drink_id, count, checkin_time)
    rewards.should_not be_nil
    rewards.should have(1).rewards

  end

end