require 'net/http'
require 'net/https'
class UserSessionsController < ApplicationController
  def create()
  	token = params[:token]
  	user_session = UserSession.new(:token => token)
	user_session.save
	call_facebook(token)

  end
  def call_facebook(token)
	url = 'graph.facebook.com'
	url_encode_token = CGI::escape(token)
	query = '&sdk=ios&sdk_version=2&format=json'
	path = '/me?access_token='+url_encode_token + query

	puts 'url' + url
	puts 'path ' + path
	http = Net::HTTP.new(url, 443)
	http.use_ssl = true
	resp, data = http.get2(path, {'User-Agent' => 'FacebookConnect'})
  end

  def destroy
  end

end
