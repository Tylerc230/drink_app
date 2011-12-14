require 'reward'
class RewardEngine
	attr_accessor :count, :drink_type

	def initialize user_id
    @user_id = user_id
	end

	def evaluate(drink_id, count, checkin_time)
    rewards = prefilter_rewards drink_id, count, checkin_time
    rewards.each do |reward|
      reward.reward_conditions.each do |condition|

      end
    end
    return rewards.empty? ? nil : rewards
  end

  def prefilter_rewards drink_id, count, checkin_time
    current_drink = Drink.find(drink_id)
    tag_strings = current_drink.tag_list.collect{|tag| "'#{tag}'"}.join(',')
    failing_conditions = [
        create_sql_for_reward_condition(RewardCondition::RC_DRINK_TYPE, tag_strings, checkin_time),
        create_sql_for_reward_condition(RewardCondition::RC_BEFORE_TIME, tag_strings, checkin_time),
        create_sql_for_reward_condition(RewardCondition::RC_AFTER_TIME, tag_strings, checkin_time)
    ]
    failing_rewards = "SELECT reward_id FROM reward_conditions WHERE #{failing_conditions.join(' OR ')}"
    potential_passing_rewards = "select * from rewards where id not in (#{failing_rewards})"
    Reward.find_by_sql(potential_passing_rewards)
  end

  #these sql statements are used to filter out rewards which wont be awarded
  def create_sql_for_reward_condition condition, tag_string, checkin_time
    case condition
      when RewardCondition::RC_DRINK_TYPE
        filter_condition = "value NOT IN (#{tag_string})" #drinks of a certain type
      when RewardCondition::RC_BEFORE_TIME
        filter_condition = "CAST(value as integer) < #{checkin_time}" #drinks before a certain time
      when RewardCondition::RC_AFTER_TIME
        filter_condition = "CAST(value as integer) > #{checkin_time}" #drinks after a certain time
    end
    "condition_type = #{condition} AND #{filter_condition}"
  end

end
