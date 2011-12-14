require 'checkin'
require 'time'
FactoryGirl.define do

  factory :checkin do
    user_id 1
    item_id 1
    count 1
    session_id 0
    checkin_time {DateTime.now}
  end

  factory :drink do
  end

  factory :reward do
  end

  factory :reward_condition do
  end

end