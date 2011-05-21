class UserSession < ActiveRecord::Base
	attr_accessible(:token, :fbid)
	validates(:token, :presence => true)
	def initialize(params = {})
		super
		@token = params[:token]
		@fbid = params[:fbid]
	end
end
