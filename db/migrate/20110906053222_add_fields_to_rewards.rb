class AddFieldsToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :condition, :string
    add_column :rewards, :meta_data, :string
    add_column :rewards, :tag, :string
    add_column :rewards, :title, :string
    add_column :rewards, :text, :string
  end

  def self.down
    remove_column :rewards, :text
    remove_column :rewards, :title
    remove_column :rewards, :tag
    remove_column :rewards, :meta_data
    remove_column :rewards, :condition
  end
end
