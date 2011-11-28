class Facebook

	def get_fb_user_for_token(token)
    me = facebook_fql('SELECT first_name, last_name, uid, pic_square FROM user where uid = me()', token)
    error = me.instance_of?(Hash) && me['error_code']
    raise me if error
		return me.last
	end

	def get_fb_friends_for_token(token)
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
