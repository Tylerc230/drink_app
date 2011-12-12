class Checkin < ActiveRecord::Base
  SESSION_DIVIDER = 12.hours
  before_save :calculate_session_id

  def calculate_session_id
    last_checkin = Checkin.find_last_by_user_id self.user_id
    if(last_checkin)
      diff = checkin_time - last_checkin.checkin_time
      if diff > SESSION_DIVIDER
        self.session_id = last_checkin.session_id + 1
      else
        self.session_id = last_checkin.session_id
      end
    else
      self.session_id = 0
    end
  end

end
