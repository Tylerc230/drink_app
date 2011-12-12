require 'checkin'
FactoryGirl.define do

  factory :checkin do
    user_id 1
    item_id 1
    count 1
    checkin_time {DateTime.now}
  end

end