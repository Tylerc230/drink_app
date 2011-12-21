class RenameItemIdToDrinkIdInCheckins < ActiveRecord::Migration
  change_table :checkins do |t|
    t.rename :item_id, :drink_id
  end
end
