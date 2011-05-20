module FacebookHelper
	def get_me(token)
		return get_facebook_method('me')
	end
	def get_facebook_method(method)
		url = 'graph.facebook.com'
		url_encode_token = CGI::escape(token)
		query = '&sdk=ios&sdk_version=2&format=json'
		path = '/#{method}?access_token='+url_encode_token + query
		http = Net::HTTP.new(url, 443)
		http.use_ssl = true
		resp, data = http.get2(path, {'User-Agent' => 'FacebookConnect'})
		return resp
	end

end
