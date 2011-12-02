class RemoveConditionFromReward < ActiveRecord::Migration
  def self.up
    change_table :rewards do |t|
      t.remove :condition, :meta_data, :tag
    end
  end

  def self.down
    change_table :rewards do |t|
      t.string :condition, :meta_data, :tag
    end
  end
end
