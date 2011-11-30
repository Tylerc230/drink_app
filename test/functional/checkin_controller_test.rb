require 'test_helper'

class CheckinControllerTest < ActionController::TestCase

  def setup
    super
    @controller = CheckinsController.new
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
