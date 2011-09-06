class RewardEngine
	attr_accessor :count, :drink_type

	def initialize(rewards)
	end

	def evaluate(drink_type, count)
		@count = count
		@drink_type = drink_type
	end

end
