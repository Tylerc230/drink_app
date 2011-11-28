require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    super
    @token = "bTskHp8ckMfJz93YUNP1_W-_Mseso2kAiH-UqmnZL8I.eyJpdiI6InF6RXRiMWdrSV9uOHJlY0EyTTUxWlEifQ.sPpxvWZov3Y6XmO9Si1P99z0mi9oJeYwrQvYOvaxvU5GBNPHcfDGjFstUHeYrqtBHx9Nvj633XT5S0f8ymfgfwMUuc2BkShvaT_oeEvfo99EfUOb9FWJGCa2upNzBL42KuM06jDF7lKixTWJwzlXrg"
    @not_token = "0BpMQYks_1AXNLJddD2K8neLZyYrCNHOGT4kyvQrZ6E.eyJpdiI6IjJ4eG9QOUxlQTlHdW4xQWxwWHBCdkEifQ.xn_GBFmYu-vEDlmN7WN-O5mi2u838TqabUr56Wpn5whrgtHb8Ey5KiyQVQfAsQBO4JvY1WT4YkK-T55yuxTxmqYrUiyS81hq0uuLfoyvRjXp2bWfmUSYu_ID9xwnX1r_10ZM7kIBKGyb2rLEqMtXOw"
  end

  # Replace this with your real tests.
  test "get me from facebook" do
    me = nil
    assert_nothing_raised{
      me = User.get_user_for_token(@token)
    }
    assert_not_nil me
    assert_not_nil me.pic_square
    assert_not_nil me.first_name
    assert_not_nil me.last_name
    assert_not_nil me.fbid
  end

  test "get unknown user from facebook" do
    assert_raise(RuntimeError){
      me = User.get_user_for_token(@not_token)
    }
  end

  test "get friends" do
    friends = User.get_friends_for_token(@token)
    assert friends.count > 0
    friend = friends[0]
    assert_not_nil friend
    assert_not_nil friend.pic_square
    assert_not_nil friend.first_name
    assert_not_nil friend.last_name
    assert_not_nil friend.is_app_user
    assert_not_nil friend.fbid
  end
end
