require 'reward'
class RewardEngine
	attr_accessor :count, :drink_type

	def initialize user_id
    @user_id = user_id
	end

	def evaluate(drink_id, count, checkin_time, current_session_id)
    seconds_today = checkin_time.seconds_since_midnight
    rewards = prefilter_rewards drink_id, count, seconds_today
    all_rewards = rewards
    final_rewards = []
    rewards.each do |reward|
      final_rewards << reward if reward_valid count, reward, current_session_id
    end
    return final_rewards.empty? ? nil : final_rewards
  end

  def reward_valid count, reward, current_session_id
    total_drinks_for_reward = reward.condition_of_type(RewardCondition::RC_AMOUNT)
    drink_type = reward.condition_of_type(RewardCondition::RC_DRINK_TYPE)
    before_time = reward.condition_of_type(RewardCondition::RC_BEFORE_TIME)
    after_time = reward.condition_of_type(RewardCondition::RC_AFTER_TIME)
    session_restriction = reward.condition_of_type(RewardCondition::RC_SESSION_RESTRICTION)

    checkin_relation = Checkin.where(:user_id => @user_id).tagged_with(drink_type).before_time(before_time).after_time(after_time)
    if session_restriction
      checkin_relation = checkin_relation.where('session_id = ?', current_session_id)
    end
    num_drinks_meeting_conditions = checkin_relation.count
    drinks_needed_to_earn_reward = total_drinks_for_reward - num_drinks_meeting_conditions

    return count >= drinks_needed_to_earn_reward

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
