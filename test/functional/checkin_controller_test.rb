require 'test_helper'

class CheckinControllerTest < ActionController::TestCase

  def setup
    super
    @controller = CheckinsController.new
  end

  test "should get create" do
    params = FactoryGirl.attributes_for(:checkin)
    post :create, params
    assert_response :success
  end

end
