class Drink < ActiveRecord::Base
	attr_accessible(:name)
  acts_as_taggable

	def tags=(tags)
		self.tag_list = tags.gsub(':', ', ')
  end

  def serializable_hash(options)
    super(:only => [:name], :methods => [:tag_list])
  end

end
