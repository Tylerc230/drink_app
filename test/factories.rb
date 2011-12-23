require 'checkin'
require 'time'
FactoryGirl.define do

  factory :checkin do
    user_id 1
    drink_id 1
    count 1
    checkin_time 0.hours
  end

  factory :drink do
  end

  factory :reward do
  end

  factory :reward_condition do
  end

end