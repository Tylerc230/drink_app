require 'net/http'
require 'net/https'
require File.join(File.dirname(__FILE__), '..', 'helpers/facebook_helper')

class UserSessionsController < ApplicationController
	def create()
		token = params[:token]
		data = {}
		data['me'] = get_me(token)
		data['friends'] = get_friends(token)
		fbid = data['me'].id
		user_session = UserSession.new(:token => token, :fbid => fbid)
		user_session.save
		render :text => data.to_json
	end

	def destroy
	end

	def get_me(token)
		return facebook_fql('SELECT first_name, last_name, uid, pic_square, is_app_user FROM user where uid = me()', token)
	end

	def get_friends(token)
		return facebook_fql('SELECT first_name, last_name, uid, pic_square, is_app_user FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=me())', token)
	end

	def facebook_fql(query, token)
		url = 'api.facebook.com'
		url_encode_token = CGI::escape(token)
		url_encode_query = CGI::escape(query)
		path = "/method/fql.query?format=json&query=#{url_encode_query}" + "&access_token=#{url_encode_token}"
		http = Net::HTTP.new(url, 443)
		http.use_ssl = true
		resp, data = http.get2(path, {'User-Agent' => 'FacebookConnect'})
		return ActiveSupport::JSON.decode(data)
		
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
