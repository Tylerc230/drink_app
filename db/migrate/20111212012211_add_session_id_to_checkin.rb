class AddSessionIdToCheckin < ActiveRecord::Migration
  def self.up
    add_column :checkins, :session_id, :integer
    #This date time will be local to the client
    add_column :checkins, :checkin_time, :datetime
  end

  def self.down
    remove_column :checkins, :session_id
    remove_column :checkins, :checkin_time
  end

end
