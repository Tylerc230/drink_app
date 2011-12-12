require 'test_helper'
require 'checkin'

class CheckinTest < ActiveSupport::TestCase
  test "checkin is in same session" do
    create_2_checkins_with_time_diff (Checkin::SESSION_DIVIDER - 1.hour)
    assert_not_nil(@current_checkin.session_id, "The session id should be set")
    assert_equal(@last_checkin.session_id, @current_checkin.session_id, "The session id should be the same as the last one")
  end
  test "checkin is in different session" do
    create_2_checkins_with_time_diff (Checkin::SESSION_DIVIDER + 1.hour)
    assert_not_nil(@current_checkin.session_id, "The session id should be set")
    assert_equal(@last_checkin.session_id + 1, @current_checkin.session_id, "The session id should be one more than the last")
  end

  def create_2_checkins_with_time_diff(time_diff)
    last_checkin_time = DateTime.new(2011, 12, 11, 18)
    @last_checkin = FactoryGirl.create(:checkin, :checkin_time => last_checkin_time)

    current_checkin_time = last_checkin_time + time_diff
    @current_checkin = FactoryGirl.create(:checkin, :checkin_time => current_checkin_time)
  end

end
