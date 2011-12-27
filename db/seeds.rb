# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#Drink.delete_all
#drink_csv  = File.open("./content/drinks.csv", "r")
#drink_csv.each_line.drop(1).each do |line|
  #entries = line.split(',')
  #drink = Drink.create(:name => entries[0].strip)
  #tags = entries[1].strip.gsub(':', ', ')
  #drink.tag_list = tags
  #drink.save
#end

#Reward.delete_all
#reward_csv = File.open("./content/rewards.csv", "r")
#reward_csv
def seedDBFromCSV(directory, csv_file_name)
	csv_file_path = directory + csv_file_name
	return if File.zero?(csv_file_path)
	csv_file = File.open(csv_file_path, "r")
	model_class = File.basename(csv_file_name, ".*").camelize.singularize.constantize
	model_class.delete_all
	method_names = csv_file.each_line.first.split(',')
	csv_file.each_line.each do |line|
	  entries = line.split(',')
	  row = model_class.create()
	  method_names.zip(entries).each do |method, entry|
	  	row.send("#{method.strip}=", entry.strip)
	  end
	  row.save
	end
end

path = "./content/"
Dir.foreach(path) do |filename|
	if(File.extname(filename) == ".csv")
		seedDBFromCSV path, filename
	end
end


