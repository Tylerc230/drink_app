class RenameTypeColumnInRewardCondition < ActiveRecord::Migration
  def self.up
    change_table :reward_conditions do |t|
      t.rename :type, :condition_type
    end
  end
  def self.down
    change_table :reward_conditions do |t|
      t.rename :condition_type, :type
    end
  end
end
