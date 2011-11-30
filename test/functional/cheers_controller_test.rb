require 'test_helper'

class CheersControllerTest < ActionController::TestCase
  test "should get send_cheers" do
    post :create, :fbid => "123456789"
    assert_response :success
  end

end
