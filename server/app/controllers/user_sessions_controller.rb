require 'net/http'
require 'net/https'
require File.join(File.dirname(__FILE__), '..', 'helpers/facebook_helper')

class UserSessionsController < ApplicationController
	def create()
		token = params[:token]
		data = {}
#TODO combine get_me and get_friends call to facebook
		data['me'] = get_fb_me(token).last
		fbid = data['me']['id']
		user_session = UserSession.where(:fbid => fbid)[0]
		if(!user_session)
			user_session = UserSession.new(:token => token, :fbid => fbid)
		else
			user_session.token = token
			friend_data = get_friend_data(get_fb_friends(token))
			puts 'friend data' + friend_data
			data['friends'] = friend_data
		end
		user_session.save
		render :text => data.to_json
	end

	def destroy
	end

	def get_fb_me(token)
		return facebook_fql('SELECT first_name, last_name, uid, pic_square FROM user where uid = me()', token)
	end

	def get_friend_data(friends)
		friend_ids = []
		friends.each do |friend|
			if(friend['is_app_user'])
				friend_ids = friend['uid']
			end
		end
		friends_data = get_data_for_users(friend_ids)
#iterate over all friends from db
		friends_data.each do |data|
#and match them up with friend from facebook
			friends.each do |friend|
				if(data.fbid == friend['uid'])
					friend['data'] = data
				end
			end
		end
		return friends
	end

	def get_data_for_users(uids)
		UserSession.where(:fbid => uids)
		
	end

	def get_fb_friends(token)
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

end
