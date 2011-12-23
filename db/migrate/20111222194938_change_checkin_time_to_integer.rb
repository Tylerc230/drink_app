class ChangeCheckinTimeToInteger < ActiveRecord::Migration
  def self.up
    change_table :checkins do |t|
      t.remove :checkin_time
      t.integer :checkin_time
    end
  end

  def self.down
    change_table :checkins do |t|
      t.remove :checkin_time
      t.datetime :checkin_time
    end
  end
end
