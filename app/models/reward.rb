class Reward < ActiveRecord::Base
  has_many :reward_conditions
end
