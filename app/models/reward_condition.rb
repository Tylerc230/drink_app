class RewardCondition < ActiveRecord::Base
  belongs_to :reward
  RC_DRINK_TYPE = 1
  RC_AMOUNT_PER_SESSION = 2
  RC_BEFORE_TIME = 3
  RC_AFTER_TIME = 4
end
