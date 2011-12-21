# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
def create_beer
  @budweiser = Factory(:drink, :name => 'Budweiser', :tag_list => 'beer, budweiser, domestic')
  @coors = Factory(:drink, :name => 'Coors', :tag_list => 'beer, coors, domestic')
end

def create_mimosa
  @mimosa = Factory(:drink, :name => 'Mimosa', :tag_list => 'mimosa, fruity')
end

def create_joe_sixpack
  @six_pack_reward = Factory(:reward, :title => "Joe Six Pack!", :text => "Youve been awarded this award for drinking 6 beers")
  Factory(:reward_condition, :reward => @six_pack_reward, :condition_type => RewardCondition::RC_DRINK_TYPE, :value => 'beer')
  Factory(:reward_condition, :reward => @six_pack_reward, :condition_type => RewardCondition::RC_AMOUNT, :value => '6')
  Factory(:reward_condition, :reward => @six_pack_reward, :condition_type => RewardCondition::RC_SESSION_RESTRICTION, :value => '1')
end

def create_bottomless_mimosa
  @bottomless_mimosa_reward = Factory(:reward, :title => "Bottomless Mimosas", :text => "You\'ve achieved bottomless mimosas")
  Factory(:reward_condition, :reward_id => @bottomless_mimosa_reward.id, :condition_type => RewardCondition::RC_DRINK_TYPE, :value => 'mimosa')
  Factory(:reward_condition, :reward_id => @bottomless_mimosa_reward.id, :condition_type => RewardCondition::RC_BEFORE_TIME, :value => '46800')
end

