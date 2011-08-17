require 'test_helper'
require 'user_sessions_controller'

class UserSessionsControllerTest < ActiveSupport::TestCase
  def setup
    @token = "7BpMQYks_1AXNLJddD2K8neLZyYrCNHOGT4kyvQrZ6E.eyJpdiI6IjJ4eG9QOUxlQTlHdW4xQWxwWHBCdkEifQ.xn_GBFmYu-vEDlmN7WN-O5mi2u838TqabUr56Wpn5whrgtHb8Ey5KiyQVQfAsQBO4JvY1WT4YkK-T55yuxTxmqYrUiyS81hq0uuLfoyvRjXp2bWfmUSYu_ID9xwnX1r_10ZM7kIBKGyb2rLEqMtXOw"
    @not_token = "0BpMQYks_1AXNLJddD2K8neLZyYrCNHOGT4kyvQrZ6E.eyJpdiI6IjJ4eG9QOUxlQTlHdW4xQWxwWHBCdkEifQ.xn_GBFmYu-vEDlmN7WN-O5mi2u838TqabUr56Wpn5whrgtHb8Ey5KiyQVQfAsQBO4JvY1WT4YkK-T55yuxTxmqYrUiyS81hq0uuLfoyvRjXp2bWfmUSYu_ID9xwnX1r_10ZM7kIBKGyb2rLEqMtXOw"
    @user_session = UserSessionsController.new
  end
  # Replace this with your real tests.
  test "get me from facebook" do
    me = @user_session.get_fb_me(@token)
    assert_not_nil me
    assert me.count > 0
    me = me.last
    puts me
    assert_not_nil me
  end
  test "get unknown user from facebook" do
    me = @user_session.get_fb_me(@not_token)
    assert me['error_code'] == 1
  end
  test "get friends" do
    friends = @user_session.get_fb_friends(@token)
    assert friends.count > 0
    friend = friends[0]
    assert_not_nil friend
    puts friend
  end
end
