class User < ActiveRecord::Base
	attr_accessible(:token, :fbid)
  attr_accessor(:first_name, :last_name, :pic_square, :is_app_user)
	validates(:token, :presence => true)

	def initialize(params = {})
		super
		@token = params[:token]
		@fbid = params[:fbid]
  end

  #This data is not persisted to the database (no need to duplicate fb data in our database)
  def set_values_from_facebook(facebook_data)
    @pic_square = facebook_data['pic_square']
    @first_name = facebook_data['first_name']
    @last_name = facebook_data['last_name']
    @is_app_user = facebook_data['is_app_user']
  end

  #forces to_json to exclude created_at, updated_at etc and to include accessors methods
  def serializable_hash(options)
    super(:except => [:created_at, :updated_at, :token], :methods => [:first_name, :last_name, :pic_square, :is_app_user])
  end

  def self.get_user_for_token (token)
#TODO combine get_me and get_friends call to facebook
    facebook = Facebook.new
    me = facebook.get_fb_user_for_token(token)
    fbid = me['id'].to_s
    user = User.find_or_create_by_fbid(fbid)
    user.token = token
    user.set_values_from_facebook(me)
    user.save
    user
  end

  def self.get_friends_for_token(token)
    facebook = Facebook.new
    #get friend data from facebook
    facebook_friends = facebook.get_fb_friends_for_token(token)
    #create user for each friend whether they are an app user or not
    friends = []
    facebook_friends.each do |facebook_friend|
      fbid = facebook_friend['uid']
      friend = User.find_or_create_by_fbid(fbid.to_s)
      friend.set_values_from_facebook(facebook_friend)
      friends << friend
    end
    friends
  end
end
