require 'net/http'
require 'net/https'
require 'facebook'

class UserSessionsController < ApplicationController
	def create
		token = params[:token]
		data = {}
    status = 200
    begin
      data['me'] = User.get_user_for_token(token)
      data['friends'] = User.get_friends_for_token(token)
      data['drinks'] = Drink.all
    rescue RuntimeError => re
      data[:error] = re.message
      status = 404
    end
		render :text => data.to_json, :status => status
	end
end
