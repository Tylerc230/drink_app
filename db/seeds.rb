# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Drink.delete_all
drink_csv  = File.open("./content/drinks.csv", "r")
drink_csv.each_line.drop(1).each do |line|
  entries = line.split(',')
  drink = Drink.create(:name => entries[0].strip)
  tags = entries[1].strip.gsub(':', ', ')
  drink.tag_list = tags
  drink.save
end

