require 'reward'
class RewardEngine
	attr_accessor :count, :drink_type

	def initialize user_id
    @user_id = user_id
	end

	def evaluate(drink_id, count, checkin_time)
		@count = count
		@drink_id = drink_id
    current_drink = Drink.find(drink_id)
    tag_strings = current_drink.tag_list.collect{|tag| "'#{tag}'"}.join(',')
    failing_conditions = [
      "condition_type = #{RewardCondition::RC_DRINK_TYPE} AND value NOT IN (#{tag_strings})", #drinks of a certain type
      "condition_type = #{RewardCondition::RC_BEFORE_TIME} AND CAST(value as integer) < #{checkin_time}", #drinks before a certain time
      "condition_type = #{RewardCondition::RC_AFTER_TIME} AND CAST(value as integer) > #{checkin_time}" #drinks after a certain time
    ]
    failing_rewards = "SELECT reward_id FROM reward_conditions WHERE #{failing_conditions.join(' OR ')}"
    potential_passing_rewards = "select * from rewards where id not in (#{failing_rewards})"
    rewards = Reward.find_by_sql(potential_passing_rewards);
    return rewards.empty? ? nil : rewards
	end

end
