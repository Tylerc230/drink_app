require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  def setup
    @controller = UserSessionsController.new
  end
  test "should get create" do
    post :create, :token => "bTskHp8ckMfJz93YUNP1_W-_Mseso2kAiH-UqmnZL8I.eyJpdiI6InF6RXRiMWdrSV9uOHJlY0EyTTUxWlEifQ.sPpxvWZov3Y6XmO9Si1P99z0mi9oJeYwrQvYOvaxvU5GBNPHcfDGjFstUHeYrqtBHx9Nvj633XT5S0f8ymfgfwMUuc2BkShvaT_oeEvfo99EfUOb9FWJGCa2upNzBL42KuM06jDF7lKixTWJwzlXrg"
    assert_response :success
  end

end
