class Reward < ActiveRecord::Base
  has_many :reward_conditions
  def condition_of_type condition_type
    conditions = self.reward_conditions.where(:condition_type => condition_type)
    condition = conditions.last
    default_value = default_value_for_type (condition_type)
    condition.nil? ?  default_value : condition.condition_value
  end

  def default_value_for_type type
    case type
      when RewardCondition::RC_DRINK_TYPE
        return false
      when RewardCondition::RC_AMOUNT
        return 1
      when RewardCondition::RC_SESSION_RESTRICTION
        return false
      when RewardCondition::RC_BEFORE_TIME
        return false
      when RewardCondition::RC_AFTER_TIME
        return false
    end
  end
end
