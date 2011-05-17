class UserSessionsController < ApplicationController
  def create()
  	token = params[:token]
  	user_session = UserSession.new(:token => token)
	user_session.save
  end

  def destroy
  end

end
