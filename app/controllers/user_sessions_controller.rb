require 'net/http'
require 'net/https'
require 'facebook'

class UserSessionsController < ApplicationController
	def create()
		token = params[:token]
		data = {}
    data['me'] = User.get_user_for_token(token)
    data['friends'] = User.get_friends_for_token(token)
    data['drinks'] = get_drink_data
		render :text => data.to_json
	end


  def get_drink_data
    rows = Drink.all
    data = []
    rows.each do |row|
      drink = {}
      drink['name'] = row.name
      drink['tags'] = row.tags.collect {|t| t.name }.join(",")
      data.push(drink)
    end
    return data
  end

end
