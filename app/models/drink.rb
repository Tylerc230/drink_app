class Drink < ActiveRecord::Base
	attr_accessible(:name)
  acts_as_taggable_on :tags
  has_many :checkins

	def tags=(tags)
		self.tag_list = tags.gsub(':', ', ')
  end

  def add_tag tag
    self.tag_list.add tag
  end

  def add_tag
    ""
  end

  def serializable_hash(options)
    super(:only => [:name], :methods => [:tag_list])
  end

end
