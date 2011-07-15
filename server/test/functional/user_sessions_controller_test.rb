require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get create" do
    post :create
    assert_response :success
  end

end
