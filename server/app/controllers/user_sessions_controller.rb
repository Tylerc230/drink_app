require 'net/http'
require 'net/https'
require File.join(File.dirname(__FILE__), '..', 'helpers/facebook_helper')

class UserSessionsController < ApplicationController
	def create()
		token = params[:token]
		data = {}
		data['me'] = get_me(token)
		data['friends'] = get_friends(token)

		#converts to dict
		user_info = data.as_json
		fbid = user_info.id
		user_session = UserSession.new(:token => token, :fbid => fbid)
		user_session.save

		render :text => data.to_json
	end

	def destroy
	end

	def get_me(token)
		return get_facebook_method('me', token)
	end
	def get_friends(token)
		return get_facebook_method('me/friends', token)
	end
	def get_facebook_method(method, token)
		url = 'graph.facebook.com'
		url_encode_token = CGI::escape(token)
		query = '&sdk=ios&sdk_version=2&format=json'
		path = "/#{method}?access_token="+url_encode_token + query
		http = Net::HTTP.new(url, 443)
		http.use_ssl = true
		resp, data = http.get2(path, {'User-Agent' => 'FacebookConnect'})
		return data
	end

end
