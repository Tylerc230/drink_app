class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
