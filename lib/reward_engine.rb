class RewardEngine
	attr_accessor :count, :drink_type

	def initialize
	end

	def evaluate(drink_id, count)
		@count = count
		@drink_id = drink_id
	end

end
