class CreateRewardConditions < ActiveRecord::Migration
  def self.up
    create_table :reward_conditions do |t|
      t.integer :reward_id
      t.integer :type
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :reward_conditions
  end
end
