class Drink < ActiveRecord::Base
	attr_accessible(:name)
  acts_as_taggable
  has_many :checkins

	def tags=(tags)
		self.tag_list = tags.gsub(':', ', ')
  end

  def serializable_hash(options)
    super(:only => [:name], :methods => [:tag_list])
  end

end
