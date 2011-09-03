require 'net/http'
require 'net/https'
require 'facebook'

class UserSessionsController < ApplicationController
	def create()
		token = params[:token]
		data = {}
#TODO combine get_me and get_friends call to facebook
        facebook = Facebook.new
        me = facebook.get_fb_me(token)
        error = me.instance_of?(Hash) && me['error_code']
        if(error)
          data['error_code'] = error
          data['error_msg'] = me['error_msg']
        else
          data['me'] = me.last
          fbid = data['me']['id'].to_s
          user_session = UserSession.where(:fbid => fbid)[0]
          if(!user_session)
              user_session = UserSession.new(:token => token, :fbid => fbid)
          else
              user_session.token = token
              friend_data = get_friend_data(facebook.get_fb_friends(token))
              data['friends'] = friend_data
          end
          data['drinks'] = get_drink_data
          user_session.save
        end

		render :text => data.to_json
	end

	def destroy
	end

	def get_friend_data(friends)
		friend_ids = []
		friends.each do |friend|
			if(friend['is_app_user'])
				friend_ids << friend['uid']
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
		UserSession.where(:fbid => uids.collect{|uid| uid.to_s})
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
