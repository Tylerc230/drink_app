require 'net/http'
require 'net/https'
require 'facebook'

class UserSessionsController < ApplicationController
	def create
		token = params[:token]
		data = {}
    data['me'] = User.get_user_for_token(token)
    data['friends'] = User.get_friends_for_token(token)
    data['drinks'] = Drink.all
		render :text => data.to_json
	end
end
