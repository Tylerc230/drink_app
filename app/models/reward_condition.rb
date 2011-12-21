class RewardCondition < ActiveRecord::Base
  belongs_to :reward
=begin
  These different types of conditions have different meanings
  when used in conjunction together.
  drink_type + amount: a number of drinks of a specific type
  drink_type + before_time/after_time: that drink type in that range
  session_restriction means + amount + type: a number of drinks of type this session
=end

  RC_DRINK_TYPE = 1
  RC_AMOUNT = 2
  RC_BEFORE_TIME = 3
  RC_AFTER_TIME = 4
  RC_SESSION_RESTRICTION = 5

  def condition_value
    type = self.condition_type
    value = self.value
    case type
      when RC_AMOUNT
        value.to_i
      when RC_DRINK_TYPE
        value.to_s
      when RC_BEFORE_TIME
        value.to_i
      when RC_AFTER_TIME
        value.to_i
      when RC_SESSION_RESTRICTION
        value.to_i
    end
  end
end
