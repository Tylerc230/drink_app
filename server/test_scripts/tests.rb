#!/usr/bin/ruby
require 'optparse'
require 'net/http'

def do_login(token)
	url = URI.parse("http://localhost:3000/user_sessions")
	res = Net::HTTP.post_form(url, {'token' => token})
	puts res.body
end

options = {}
OptionParser.new do |opts|
	options[:test] = nil
	opts.on('-t', '--test TEST', 'Test to run') do |test|
		options[:test] = test
	end
	options[:token] = "IP4fWh9uCW22BAYeG2fQXwKQ463rYVYa3mZvY2VCsLs.eyJpdiI6IlpBYlRpNFRKT3d0dHlkQzQyTklNVEEifQ.pgrQQM1EixbZZSJ_HfTpHXToI6g32Pjb49zc_ZBgsZ_MtIBIf2CfQpBv3INLje-AN91ohK8zB5hb2hV3MxQkAHTplvZSK7ec-N1-VjmsTfVofcLUhcH1Da4qQtdSPp8qkwLiZ548cCh3CyroOFE1xw"
	opts.on( '-k', '--token TOKEN', 'Facebook token') do |token|
		options[:token] = token
	end
	opts.on( '-h', '--help', 'Display this screen' ) do
		puts opts
		exit
	end
end.parse!

test =  options[:test]

case test
	when "login"
		token = options[:token]
		do_login token
	when "checkin"
		puts "checking in"
	else
		puts "need test"
end


