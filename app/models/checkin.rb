class Checkin < ActiveRecord::Base
  SESSION_DIVIDER = 12.hours
  #Must be before_save because we use the most recent checkin to do the session_id calculation
  before_create :save_session_id
  belongs_to :drink

  scope :tagged_with, lambda { |tag|
    {
        :joins => "INNER JOIN taggings ON taggings.taggable_id = checkins.drink_id\
                   INNER JOIN tags ON tags.id = taggings.tag_id AND taggings.taggable_type = 'Drink'",
        :conditions => ["tags.name = ?", tag]
    }
  }
  scope :before_time, lambda { |time|
    if time
      where("checkin_time < ?", time.to_i)
    end
  }

  scope :after_time, lambda { |time|
    if time
      where("checkin_time > ?", time.to_i)
    end
  }

  def calculate_session_id
    last_checkin = Checkin.find_last_by_user_id self.user_id
    #last_checkin = Checkin.where(:user_id => self.user_id).order("id desc").limit(2).last
    if(last_checkin)
      diff = checkin_time - last_checkin.checkin_time
      if diff > SESSION_DIVIDER
        new_session_id = last_checkin.session_id + 1
      else
        new_session_id = last_checkin.session_id
      end
    else
      new_session_id = 0
    end
    new_session_id
  end

  def save_session_id
    self.session_id = calculate_session_id
  end

end
