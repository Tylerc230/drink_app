require 'test_helper'

class CheersControllerTest < ActionController::TestCase
  test "should get send_cheers" do
    get :send_cheers
    assert_response :success
  end

end
