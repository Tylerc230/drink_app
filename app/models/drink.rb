class Drink < ActiveRecord::Base
	attr_accessible(:name, :tags)
  acts_as_taggable_on :tags
  has_many :checkins
  accepts_nested_attributes_for :tags

  def tag_ids=(tag_ids)
    tag_names = tag_ids.collect do |tag_id|
      if not tag_id.empty?
        ActsAsTaggableOn::Tag.find(tag_id.to_i).name
      end
    end
    self.tag_list = tag_names.join(",")

  end

	def tags=(tags)
		self.tag_list = tags.gsub(':', ', ')
  end

  #This is used to serialize drink objects to json for transport
  def serializable_hash(options)
    super(:only => [:name], :methods => [:tag_list])
  end

end
