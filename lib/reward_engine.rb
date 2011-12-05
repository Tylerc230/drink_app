class RewardEngine
	attr_accessor :count, :drink_type

	def initialize user_id
    @user_id = user_id
	end

	def evaluate(drink_id, count)
		@count = count
		@drink_id = drink_id
    current_drink = Drink.find(drink_id)
    tag_strings = current_drink.tag_list.collect{|tag| "'#{tag}'"}.join(',')
    failing_condition_sql = "SELECT reward_id FROM reward_conditions WHERE type = 1 AND value NOT IN (#{tag_strings})"
    get_rewards_sql = "select * from rewards where id not in (#{failing_condition_sql})"
    rewards = Reward.find_by_sql(get_rewards_sql);
    return rewards.empty? ? nil : rewards
	end

end
