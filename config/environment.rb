# Load the rails application
require File.expand_path('../application', __FILE__)

#Don't include the type of object as the root of the json representation when calling to_json
ActiveRecord::Base.include_root_in_json = false

# Initialize the rails application
DrinkApp::Application.initialize!
