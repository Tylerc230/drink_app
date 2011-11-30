require 'test_helper'

class CheckinControllerTest < ActionController::TestCase

  def setup
    super
    @controller = CheckinsController.new
  end

  test "should get create" do
    post :create, {:user_id => 12345678, :item_id => "some_item_id", :count => 1}
    assert_response :success
  end

end
