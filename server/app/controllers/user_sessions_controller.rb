require 'net/http'
require 'net/https'
class UserSessionsController < ApplicationController
  def create()
  	puts "HELLOW WORLD"
  	token = params[:token]
  	user_session = UserSession.new(:token => token)
	user_session.save
	resp = get_me(token)
	puts 'return ' + resp

  end

  def destroy
  end

end
