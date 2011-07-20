class Drink < ActiveRecord::Base
	attr_accessible(:name)
    acts_as_taggable
end
